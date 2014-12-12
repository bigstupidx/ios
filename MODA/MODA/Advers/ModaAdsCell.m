//
//  ModaAdsCell.m
//  MODA
//
//  Created by Macbook Pro on 12/26/13.
//  Copyright (c) 2013 Ignite Software Solution. All rights reserved.
//

#import "ModaAdsCell.h"

@implementation ModaAdsCell

@synthesize cellAdsImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        cellAdsImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.cellbgView.frame.origin.x,self.cellbgView.frame.origin.y, self.cellbgView.frame.size.width, self.cellbgView.frame.size.height+105)];
//        cellAdsImg.contentMode = UIViewContentModeScaleAspectFit;
       // cellAdsImg.clipsToBounds = YES;
        //[self addSubview:cellAdsImg];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    self.btmSpaceImgViewConstrait.constant = 0;
    self.btnSpaceContentViewConstrait.constant = 0;
    self.bgViewHeightConstrait.constant = self.cellAdsImg.frame.size.height;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGSize imageSize = self.cellAdsImg.image.size;
//    CGSize imageViewSize = self.cellbgView.frame.size;//CGSizeMake(self.cellbgView.frame.size.width, self.cellbgView.frame.size.height);//self.lblImgView.frame.size;
//    
//    float imageRatio = imageSize.width / imageSize.height;
//    float viewRatio = imageViewSize.width / imageViewSize.height;
//    
//    float scale;
//    
//    if(imageRatio > viewRatio){
//        scale = imageSize.width / imageViewSize.width;
//    }else{
//        scale = imageSize.height / imageViewSize.height;
//    }
//    
//    CGRect frame = CGRectZero;
//    
//    frame.size = CGSizeMake(roundf(imageSize.width / scale), roundf(imageSize.height / scale));
//    frame.origin = CGPointMake((imageViewSize.width - frame.size.width) / 2.0, self.cellAdsImg.frame.origin.y);//(imageViewSize.height - frame.size.height) / 2.0
//    
////    CGRect cellIMG = self.cellAdsImg.frame;
//    [self.cellAdsImg setFrame:frame];
////    CGRect cellIMGNEW = self.cellAdsImg.frame;
//    [self.contentView layoutSubviews];
//    
//    [self updateConstraints];
//
//    
//    //self.btmSpaceBtImgVBGVconstrait.constant = 0;
//}

//ModaAdsCell* curCell = (ModaAdsCell*) cell;
//
//CGSize imgSize = curCell.cellAdsImg.image.size;
//CGSize imgViewSize = curCell.cellAdsImg.frame.size;//CGSizeMake(curCell.frame.size.width, curCell.cellAdsImg.frame.size.height);
//
//float imgRatio = imgSize.width / imgSize.height;
//float viewRatio = imgViewSize.width / imgViewSize.height;
//
//float scale;
//if (imgRatio > viewRatio) {
//    scale = imgSize.width / imgViewSize.width;
//} else {
//    scale = imgSize.height / imgViewSize.height;
//}
//
//CGRect frame = CGRectZero;
//
//frame.size = CGSizeMake(roundf(imgSize.width / scale), roundf(imgSize.height / scale));
//frame.origin = CGPointMake((imgViewSize.width - frame.size.width)/2.0, curCell.cellAdsImg.frame.origin.y);
//
//[curCell.cellAdsImg setFrame:frame];
//
//[cell.contentView layoutSubviews];

@end
