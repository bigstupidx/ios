//
//  Photo.h
//  Moda
//
//  Created by Zune Moe on 2/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject
@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, strong, readonly) NSURL *postURL;

+ (Photo *)photoWithImageURL:(NSURL *)imageURL title:(NSString *)title description:(NSString *)description postURL:(NSURL *)postURL;

- (id)initWithImageURL:(NSURL *)imageURL title:(NSString *)title description:(NSString *)description postURL:(NSURL *)postURL;

- (Photo*)initWithImageUrl:(NSURL*)imgUrl;
@end
