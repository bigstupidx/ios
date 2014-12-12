//
//  VideoListVC.m
//  MODA
//
//  Created by Macbook Pro on 1/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "VideoListVC.h"
#import "VideoCell.h"
#import "Video.h"
#import "ZMFMDBSQLiteHelper.h"
#import <Social/Social.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "MODAdataFetching.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"


@interface VideoListVC ()


@property (nonatomic,strong) NSMutableArray* videoArr;
@property (nonatomic,strong) UILabel* lblCellTitle;
@property (nonatomic, assign) BOOL isEndOfTableView;
@property (nonatomic, assign) BOOL  isFirstLoad;
@end

@implementation VideoListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"VIDEO";
    
    self.isFirstLoad = YES;
    
    self.navigationItem.hidesBackButton = YES;
    UIImage *buttonImage = [UIImage imageNamed:@"BackWhite.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"BackWhite.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.isEndOfTableView = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedVideoDownload:) name:@"finishedVideoDownload" object:nil];
    [self downloadVideo];
        
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Video List Screen"];
    // Send the screen view.
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadVideo
{
    self.videoArr = [NSMutableArray array];
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];
    NSArray* videoArr = [sqlHelper executeQuery:@"select * from video_list"];
    //DOWNLOAD VIDEO
    if ((videoArr.count < 3 &&  self.isFirstLoad) || self.isEndOfTableView == YES) {
        self.isEndOfTableView = NO;
        self.isFirstLoad = NO;
        if ([self connectedToInternet]) {
            [self showHud:@"Downloading Video..."];
            MODAdataFetching* dataFetcher = [[MODAdataFetching alloc] init];
            [dataFetcher videoListDownloadingWithLimit:videoArr.count+10];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
    }

    for (NSDictionary* videoDict in videoArr) {
        Video* videoObj = [[Video alloc] initWithTitle:[videoDict objectForKey:@"title"] withURL:[videoDict objectForKey:@"video_url"] withWebUrl:[videoDict objectForKey:@"web_url"]];
        [self.videoArr addObject:videoObj];
    }
    [self.tableView reloadData];

}

- (void)finishedVideoDownload:(NSNotification*)notification
{
    [self hideHud];
    self.isFirstLoad = NO;
    MODAdataFetching* dataFetcher = (MODAdataFetching*)notification.object;
    if (!dataFetcher.isVideoError && !dataFetcher.isVideoMaxOffset) {
        [self downloadVideo];
    }
    else if (dataFetcher.isVideoError) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Video Download Error" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }

    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"SCROLLVIEW Y = %f, HEIGHT = %f, CURRENT PoINT = %f, CONTENT HEIGHT = %f",scrollView.contentOffset.y,scrollView.frame.size.height,scrollView.contentOffset.y+scrollView.frame.size.height,[scrollView contentSize].height);
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) == [scrollView contentSize].height)
    {
        self.isEndOfTableView = YES;
        [self downloadVideo];
        return;
	}
}


- (BOOL)connectedToInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (void) showHud:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
}

- (void) hideHud
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.videoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellWithShare";//@"videoCell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Video* video = self.videoArr[indexPath.row];
    

    
    NSString* utubeStr = [NSString stringWithFormat:@"<iframe class='youtube-player' type='text/html' width='100%%' height='110' src='http://%@?controls=0&showinfo=0' allowfullscreen frameborder='0'></iframe>",video.vUrl];
    [cell.utubeView loadHTMLString:utubeStr baseURL:nil];

    //[(UIScrollView*)[[cell.utubeView subviews] lastObject] setScrollEnabled:NO];
    cell.vTitle.text = video.vtitle;
    cell.vTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:12];
    
    cell.cellBGview.layer.cornerRadius = 5;
    cell.cellFirstBGView.layer.cornerRadius = 5;
    
    [cell.btnFBshare addTarget:self action:@selector(fbShareOnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnFBshare.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"cellWithShare";//@"videoCell";
    VideoCell *vcell = (VideoCell*)cell;
    vcell.btnFBshare.layer.shadowOffset = CGSizeMake(-2, 2);
    vcell.btnFBshare.layer.shadowRadius = 2;
    vcell.btnFBshare.layer.shadowOpacity = 0.8;
    
    
    vcell.cellFirstBGView.layer.shadowOffset = CGSizeMake(-2, 2);
    vcell.cellFirstBGView.layer.shadowRadius = 4;
    vcell.cellFirstBGView.layer.shadowOpacity = 0.8;
    
    vcell.cellFirstBGView.layer.borderWidth = 0.5;
    vcell.cellFirstBGView.layer.borderColor = [[UIColor colorWithRed:154.0/255 green:134.0/255 blue:36.0/255 alpha:1] CGColor];

    vcell.cellBGview.layer.borderWidth = 0.5;
    vcell.cellBGview.layer.borderColor = [[UIColor colorWithRed:154.0/255 green:134.0/255 blue:36.0/255 alpha:1] CGColor];

    vcell.vTitle.backgroundColor = [UIColor colorWithRed:154.0/255 green:134.0/255 blue:36.0/255 alpha:0.5];
}

- (void)fbShareOnClick:(id)sender
{
    UIButton* btnFB = (UIButton*)sender;
    Video* vid = self.videoArr[btnFB.tag];
    
    SLComposeViewController *slComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [slComposer setInitialText:@"Check out this Video on MODA"];
    NSURL* sampleURL = [NSURL URLWithString:[vid.vWebUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [slComposer addURL:sampleURL];
    [self presentViewController:slComposer animated:YES completion:nil];

}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *CellIdentifier = @"videoCell";
//    VideoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////    NSString* utubeStr = @"<iframe class='youtube-player' type='text/html' width='100%%' height='140' src='http://www.youtube.com/embed/_HkX-TNz6wA' allowfullscreen frameborder='0'></iframe>";
////    [cell.utubeView loadHTMLString:utubeStr baseURL:nil];
//    cell.vTitle.text = @"This is the title of this video.. this is the title of this video";
//    cell.vTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:12];
//    [cell.vTitle sizeToFit];
//
//    [cell.contentView setNeedsLayout];
//    [cell.contentView layoutIfNeeded];
//    CGFloat height = cell.utubeView.frame.size.height+cell.vTitle.frame.size.height;//[cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    return height;
//
//
//}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 201.0f;
//}


//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    CGRect newBounds = webView.bounds;
//    newBounds.size.height = webView.scrollView.contentSize.height;
//    webView.bounds = newBounds;
//    
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
//    
//}

//-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    CGRect newBounds = webView.bounds;
//    newBounds.size.height = webView.scrollView.contentSize.height;
//    webView.bounds = newBounds;
//    VideoCell* cell = [cellsArr objectAtIndex:webView.tag];
//    [cell.contentView layoutSubviews];
//    cell.cellBGviewHeightCostrait.constant = webView.bounds.size.height + cell.vTitle.frame.size.height;
//    [cell layoutSubviews];
//}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    CGRect frame = webView.frame;
//    frame.size = [webView sizeThatFits:CGSizeZero];
//    frame.size.height += 20.0f; // additional padding to push it off the bottom edge
//    webView.frame = frame;
//    
//    webView.delegate = nil;
//    
//    UITableViewCell *cell =[cellsArr objectAtIndex:webView.tag];
//    [cell.contentView addSubview:webView];
//    cell.contentView.frame = frame;
//    [cell setNeedsLayout];
//    
//    webView.alpha = 1.0f;
//    
//    [self.tableView beginUpdates];
//    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:webView.tag]];
//    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
//    
//    // Storing the currently loading webView in case I need to clean it up
//    // before it finishes loading.
////    _loadingWebView = nil;
//}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
