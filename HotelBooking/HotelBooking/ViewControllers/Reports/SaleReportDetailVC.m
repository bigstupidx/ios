//
//  SaleReportDetailVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/17/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SaleReportDetailVC.h"
#import "BookListCell.h"
#import "SaleReportRoomVC.h"
#import "ZMFMDBSQLiteHelper.h"

@interface SaleReportDetailVC () <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSString* documentDirectoryFilename;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbheight;
@property (weak, nonatomic) IBOutlet UIButton *btndismiss;
@property (weak, nonatomic) IBOutlet UITableView *tbcheckindetail;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalamt;
@property (weak, nonatomic) IBOutlet UILabel *lblchinno;
@property (weak, nonatomic) IBOutlet UILabel *lblroomno;
@property (weak, nonatomic) IBOutlet UILabel *lbltitletotal;
@property (weak, nonatomic) IBOutlet UILabel *lbltitletotalamt;
@property (weak, nonatomic) IBOutlet UILabel *lbltitledate;
@property (weak, nonatomic) IBOutlet UILabel *lblchkindate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewheight;
@property (weak, nonatomic) IBOutlet UIScrollView *upscrollview;
@property (weak, nonatomic) IBOutlet UIButton *btnPrint;
@property (weak, nonatomic) IBOutlet UILabel *lblviewTitle;
- (IBAction)PrintVoucher:(id)sender;

- (IBAction)DismissThisView:(id)sender;

@end

@implementation SaleReportDetailVC

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
    
    _lblviewTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    _lblviewTitle.text = @"အေရာင္း ေဘာင္ခ်ာမ်ား";
    
    _lblroomno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblroomno.text = @"အခန္းနံပါတ္";
    
    _lblchinno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblchinno.text = @"ေဘာင္ခ်ာနံပါတ္";
    
    _lbltitletotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitletotal.text = @"စုုစုုေပါင္း";

    _lbltitletotalamt.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitletotalamt.text = @"စုုစုုေပါင္း :";
    
    _lbltitledate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitledate.text = @"ေငြေပးေခ်သည့္ေန ့ရက္ :";
    
    _lblchkindate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblchkindate.text = _chkindate;
    
    _btnPrint.layer.cornerRadius = 10;
    _btnPrint.layer.borderColor = [[UIColor blueColor] CGColor];
    _btnPrint.layer.borderWidth = 1.5f;
    
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
    _scrollviewheight.constant = _tbheight.constant + 130;
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

- (IBAction)PrintVoucher:(id)sender {
    UIImage* resultImg = [self renderScrollViewToImage];
    
    //Resize while keeping aspect ration of Original Img :) :D
    UIImage *resizedImg = [UIImage imageWithCGImage:[resultImg CGImage] scale:(resultImg.scale * 2.0) orientation:(resultImg.imageOrientation)];
    
    [self createPdf:resizedImg];
    
    NSArray *activityItems = @[[NSData dataWithContentsOfFile:self.documentDirectoryFilename]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];

}

- (IBAction)DismissThisView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tablefiller.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 204, 9999)];
    label.numberOfLines=0;
    //        label.font = [UIFont fontWithName:fontName size:textSize];
    NSDictionary* dict = _tablefiller[indexPath.row];
    label.text = dict[@"rooms"];
    
    CGSize maximumLabelSize = CGSizeMake(204, 9999);
    CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
    
    return expectedSize.height+50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"checkindetailcell";
    BookListCell* cell = (BookListCell*)[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    NSDictionary* bookdict = _tablefiller[indexPath.row];
    
    cell.cellname.text = bookdict[@"checkinno"];
    cell.cellroomno.text = bookdict[@"rooms"];
    cell.cellamt.text = [NSString stringWithFormat:@"%@ Ks", bookdict[@"total_amt"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* bookdict = _tablefiller[indexPath.row];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"check_in_no MATCHES[cd] %@", bookdict[@"checkinno"]];
    NSArray * match = [_resultArr filteredArrayUsingPredicate:predicate];
    
    NSMutableArray* mupassedarr = [NSMutableArray new];
    for (NSDictionary* dict in match) {
        int detailid = [dict[@"id"] intValue];
        
        ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
        NSDictionary* resultdict = [db executeQuery:[NSString stringWithFormat:@"select booking_detail_id, count(book_date) as days from tbl_booking_room_dates where booking_detail_id='%d'", detailid]].firstObject;
        
        [mupassedarr addObject:@{@"detail_id": resultdict[@"booking_detail_id"], @"days": resultdict[@"days"]}];
    }
    
    SaleReportRoomVC* nexvc = (SaleReportRoomVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SaleReportRoomVC"];
    nexvc.chkindate = _chkindate;
    nexvc.strvnum = bookdict[@"checkinno"];
    nexvc.tablefiller = [match copy];
    nexvc.totalamt = [bookdict[@"total_amt"] intValue];
    nexvc.dayArr = [mupassedarr copy];
    
    [self presentViewController:nexvc animated:YES completion:nil];
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
    self.documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"MyVoucherListReport.pdf"];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:self.documentDirectoryFilename atomically:YES];
}


@end
