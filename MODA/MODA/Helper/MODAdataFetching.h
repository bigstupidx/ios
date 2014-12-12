//
//  MODAdataFetching.h
//  MODA
//
//  Created by Macbook Pro on 1/10/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MODAdataFetching : NSObject

@property (nonatomic, assign) int count;
@property (nonatomic, assign) BOOL isGalleryMaxOffset;
@property (nonatomic, assign) BOOL isGalleryError;
@property (nonatomic, assign) BOOL isVideoMaxOffset;
@property (nonatomic, assign) BOOL isVideoError;
@property (nonatomic, assign) BOOL isArticleError;
@property (nonatomic, assign) BOOL isArticleMaxoffset;
@property (nonatomic, assign) BOOL isMoreArticleDownload;

- (void)articleDownloadWithHTTP:(NSString*)pathStr withKey:(NSString*)dictKey;
- (void)adsDownloading;
- (void)galleryDownloadingWithLimit:(int)limit;
- (void)videoListDownloadingWithLimit:(int)limit;

- (void)finishedDownloading;

@end
