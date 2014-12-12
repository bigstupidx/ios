//
//  MSAdvers.h
//  MMJunction
//
//  Created by Macbook Pro on 9/18/13.
//  Copyright (c) 2013 Ignite Software Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSAdvers : NSObject

@property (nonatomic, retain) NSString* adsUrl;
@property (nonatomic, retain) NSString* adsPosition;
@property (nonatomic, retain) NSString* adsWeburl;
//@property (nonatomic, retain) NSString* adsWebsiteUrl;
//@property (nonatomic, retain) NSString* adsStatus;
//@property (nonatomic, strong) NSString* adsPriority;

- (MSAdvers*)initWithAdsUrl:(NSString*)adsURL withPosition:(NSString*)adsPos withWebURL:(NSString*)adswebUrl;

@end
