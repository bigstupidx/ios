//
//  ArticleModel.h
//  MODA
//
//  Created by Macbook Pro on 1/20/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"
#import "ArticleGalleryModel.h"
#import "ArticleVideoModel.h"

@interface ArticleModel : JSONModel

@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* image_url;
@property (nonatomic, strong) NSString* video;
@property (nonatomic, strong) NSString<Optional> *issue;
@property (nonatomic, strong) NSArray<ArticleGalleryModel>* gallery;
@property (nonatomic, strong) NSArray<ArticleVideoModel>* video_url;
@property (nonatomic, assign) int status;

@end
