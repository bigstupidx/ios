//
//  ArticleGalleryModel.h
//  MODA
//
//  Created by Macbook Pro on 1/20/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"

@protocol ArticleGalleryModel <NSObject>

@end

@interface ArticleGalleryModel : JSONModel

@property (nonatomic, strong) NSString* gallery_img_url;

@end
