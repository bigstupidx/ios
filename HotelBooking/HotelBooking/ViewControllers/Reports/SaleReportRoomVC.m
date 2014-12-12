//
//  SaleReportRoomVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/17/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SaleReportRoomVC.h"
#import "BookListCell.h"

@interface SaleReportRoomVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbheight;
@property (weak, nonatomic) IBOutlet UIButton *btndismiss;
@property (weak, nonatomic) IBOutlet UITableView *tbcheckindetail;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalamt;
@property (weak, nonatomic) IBOutlet UILabel *lblroomno;
@property (weak, nonatomic) IBOutlet UILabel *lblprice;
@property (weak, nonatomic) IBOutlet UILabel *lbldays;
@property (weak, nonatomic) IBOutlet UILabel *lbltitletotal;
@property (weak, nonatomic) IBOutlet UILabel *lbltitleamt;
@property (weak, nonatomic) IBOutlet UILabel *lbltitledate;
@property (weak, nonatomic) IBOutlet UILabel *lblchkindate;
@property (weak, nonatomic) IBOutlet UILabel *lbltitlevno;
@property (weak, nonatomic) IBOutlet UILabel *lblvno;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewheight;
@property (weak, nonatomic) IBOutlet UIScrollView *upscrollview;
@property (strong, nonatomic) NSString* documentDirectoryFilename;
@property (weak, nonatomic) IBOutlet UILabel *lblViewTitle;


- (IBAction)DismissThisView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *printReport;
- (IBAction)PrintReport:(id)sender;

@end

@implementation SaleReportRoomVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lblViewTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    _lblViewTitle.text = @"အခန္း အေရာင္းစာရင္း";
    
    _lblroomno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblroomno.text = @"အခန္းနံပါတ္";
    
    _lblprice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblprice.text = @"အခန္းခ";
    
    _lbldays.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbldays.text = @"ေန ့ရက္ေပါင္း";
    
    _lbltitletotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitletotal.text = @"စုုစုုေပါင္း";
    
    _lbltitleamt.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitleamt.text = @"စုုစုုေပါင္း :";
    
    _lbltitledate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitledate.text = @"ေငြေပးေခ်သည့္ေန ့ရက္ :";
    
    _lblchkindate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblchkindate.text = _chkindate;
    
    _lbltitlevno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitlevno.text = @"ေဘာင္ခ်ာနံပါတ္ :";
    
    _lblvno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblvno.text = _strvnum;

    _printReport.layer.cornerRadius = 10;
    _printReport.layer.borderColor = [[UIColor blueColor] CGColor];
    _printReport.layer.borderWidth = 1.5f;
    
    _btndismiss.layer.cornerRadius = 10;
    _btndismiss.layer.borderColor = [[UIColor blueColor] CGColor];
    _btndismiss.layer.borderWidth = 1.5f;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgimg.jpg"]];
    
    _scrollview.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.85];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    float tbheight = 63 * _tablefiller.count;
    _tbheight.constant = tbheight + 30;
    _scrollviewheight.constant = 130+_tbheight.constant;
    _lblTotalamt.text = [NSString stringWithFormat:@"%d Ks", _totalamt];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)DismissThisView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tablefiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"roomdetailcell";
    BookListCell* cell = (BookListCell*)[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    NSDictionary* bookdict = _tablefiller[indexPath.row];
    
    cell.cellnrc.text = [NSString stringWithFormat:@"%@ Ks",bookdict[@"price"]];
    cell.cellroomno.text = bookdict[@"room_no"];
    cell.cellamt.text = [NSString stringWithFormat:@"%@ Ks", bookdict[@"total_amt"]];
    
    for (NSDictionary* dict in _dayArr) {
        if ([dict[@"detail_id"] isEqualToValue:bookdict[@"id"]]) {
            cell.cellbookdate.text = [NSString stringWithFormat:@"%@", dict[@"days"]];
            break;
        }
    }
    
    return cell;
}

# pragma mark - Printing Helper Methods

- (UIImage *)renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(_upscrollview.contentSize);
    {
        CGPoint savedContentOffset = _upscrollview.contentOffset;
        CGRect savedFrame = _upscrollview.frame;
        
        _upscrollview.contentOffset = CGPointZero;
        _upscrollview.frame = CGRectMake(0, 0, _upscrollview.contentSize.width, _upscrollview.contentSize.height);
        
        [_upscrollview.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _upscrollview.contentOffset = savedContentOffset;
        _upscrollview.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    //    if (image != nil) {
    //        [UIImagePNGRepresentation(image) writeToFile: @"/tmp/test.png" atomically: YES];
    //        system("open /tmp/test.png");
    //    }
    
    return image;
}

-  (void)createPdf:(UIImage *)img
{
    //a4
    CGRect pdfPageBounds = CGRectMake(0, 0, 595, 700); //
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil); {
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
        [img drawAtPoint:CGPointMake(5,5)];
    } UIGraphicsEndPDFContext();
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    self.documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"MySaleReport.pdf"];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:self.documentDirectoryFilename atomically:YES];
}



- (IBAction)PrintReport:(id)sender {
    
    UIImage* resultImg = [self renderScrollViewToImage];
    
    //Resize while keeping aspect ration of Original Img :) :D
    UIImage *resizedImg = [UIImage imageWithCGImage:[resultImg CGImage] scale:(resultImg.scale * 2.0) orientation:(resultImg.imageOrientation)];
    
    [self createPdf:resizedImg];
    
    NSArray *activityItems = @[[NSData dataWithContentsOfFile:self.documentDirectoryFilename]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}
@end
