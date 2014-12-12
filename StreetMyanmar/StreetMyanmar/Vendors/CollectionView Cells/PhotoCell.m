//
//  PhotoCell.m
//  StreetMyanmar
//
//  Created by Zune Moe on 3/14/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "PhotoCell.h"
#import "UIImageView+WebCache.h"

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCell:(MHGalleryItem *)photo
{
    self.photoImageView.layer.masksToBounds = YES;
    self.photoImageView.layer.cornerRadius = 2;
    self.photoImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.photoImageView.layer.shadowOpacity = 0.5;
    self.photoImageView.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    self.photoImageView.layer.shadowRadius = 3.0;
    self.photoImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.photoImageView.layer.shouldRasterize = YES;
    [self.photoImageView setImageWithURL:[NSURL URLWithString:photo.urlString]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
