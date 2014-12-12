//
//  Article.h
//  Moda
//
//  Created by Zune Moe on 2/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Article : NSObject
@property (retain, nonatomic) NSString *articleTitle;
@property (retain, nonatomic) NSString *articleAuthor;
@property (retain, nonatomic) NSString *articleDetails;
@property (retain, nonatomic) NSString *articleDate;
@property (retain, nonatomic) NSString *articlePhoto;
@property (retain, nonatomic) NSString *articleSubCat;
@property (retain, nonatomic) NSString *articleVideo;
@property (retain, nonatomic) NSArray *articleVideoUrl;
@property (retain, nonatomic) NSString *articleImgUrl;
@property (retain, nonatomic) NSArray *articleGallery;
//status, issue, id

- (Article*)initWithTitle:(NSString*)arTitle withDetails:(NSString*)arDesc withSubCat:(NSString*)arType withImgUrl:(NSString*)arImgUrl withVideo:(NSString*)arVideo withVideoUrl:(NSArray*)arVideoUrl withGallery:(NSArray*)arGallery;

@end
