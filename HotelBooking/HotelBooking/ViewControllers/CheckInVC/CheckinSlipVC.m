//
//  CheckinSlipVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CheckinSlipVC.h"
#import "BookListCell.h"

@interface CheckinSlipVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbheight;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;
- (IBAction)Done:(id)sender;
- (IBAction)PrintSlip:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgviewheight;
@property (weak, nonatomic) IBOutlet UILabel *lblvno;
@property (weak, nonatomic) IBOutlet UIScrollView *slipscrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slipscrollviewheight;

@property (strong, nonatomic) NSString* documentDirectoryFilename;

@end

@implementation CheckinSlipVC

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
    
    unsigned long totalAmt = 0;
    
    for (NSDictionary* dict in _tableFiller) {
        totalAmt += [dict[@"price"] intValue] * ((NSArray*)dict[@"date"]).count;
        
    }
    _lblTotalAmt.text = [NSString stringWithFormat:@"%lu", totalAmt];
    
    _lblvno.text = [NSString stringWithFormat:@"#%@", _strVoucherno];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resizetbview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resizetbview
{
    float tbheight = 44 * _tableFiller.count;
    
    _tbheight.constant = tbheight + 10;
    _slipscrollviewheight.constant = 100 + _tbheight.constant;
    
//    _bgviewheight.constant = tbheight + 100;
    
//    _slipscrollview.contentSize = CGSizeMake(_slipscrollview.frame.size.width, _slipscrollview.frame.size.height+tbheight+100);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"slipcell";
    BookListCell* cell = (BookListCell*)[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    NSDictionary* bookdict = _tableFiller[indexPath.row];
    
    cell.cellnrc.text = [NSString stringWithFormat:@"%lu", (unsigned long)((NSArray*)bookdict[@"date"]).count];
    
    cell.cellroomno.text = bookdict[@"roomno"];
    //    cell.cellroomtype.text = [NSString stringWithFormat:@"%@",bookdict[@"type"]];
    NSMutableString* muStr = [NSMutableString new];
    NSArray* arr = bookdict[@"date"];
    for (NSString* strdate in arr) {
        [muStr appendString:[NSString stringWithFormat:@"%@, ", strdate]];
    }
    
    cell.cellbookdate.text = muStr;
    cell.cellamt.text = [NSString stringWithFormat:@"%@ Ks",bookdict[@"price"]];
    
    unsigned long totalamt = [bookdict[@"price"] intValue] * ((NSArray*)bookdict[@"date"]).count;
    cell.cellroomtype.text = [NSString stringWithFormat:@"%lu",totalamt];
    
    return cell;
}

- (IBAction)Done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAllSelectedRooms" object:nil];
    }];
}

- (IBAction)PrintSlip:(id)sender {
    
    UIImage* resultImg = [self renderScrollViewToImage];
    
    //Resize while keeping aspect ration of Original Img :) :D
    UIImage *resizedImg = [UIImage imageWithCGImage:[resultImg CGImage] scale:(resultImg.scale * 2.0) orientation:(resultImg.imageOrientation)];
    
    [self createPdf:resizedImg];
    
    NSArray *activityItems = @[[NSData dataWithContentsOfFile:self.documentDirectoryFilename]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];
    
}

# pragma mark - Printing Helper Methods

- (UIImage *)renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(_slipscrollview.contentSize);
    {
        CGPoint savedContentOffset = _slipscrollview.contentOffset;
        CGRect savedFrame = _slipscrollview.frame;
        
        _slipscrollview.contentOffset = CGPointZero;
        _slipscrollview.frame = CGRectMake(0, 0, _slipscrollview.contentSize.width, _slipscrollview.contentSize.height);
        
        [_slipscrollview.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _slipscrollview.contentOffset = savedContentOffset;
        _slipscrollview.frame = savedFrame;
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
    self.documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"MySlip.pdf"];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:self.documentDirectoryFilename atomically:YES];
}


@end
