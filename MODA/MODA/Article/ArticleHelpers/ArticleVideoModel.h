//
//  ArticleVideoModel.h
//  MODA
//
//  Created by Macbook Pro on 1/20/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"


@protocol ArticleVideoModel <NSObject>

@end

@interface ArticleVideoModel : JSONModel

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* video_description;

@end
