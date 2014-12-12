//
//  Video.h
//  MODA
//
//  Created by Macbook Pro on 1/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, retain) NSString* vtitle;
@property (nonatomic, retain) NSString* vUrl;
@property (nonatomic, retain) NSString* vWebUrl;

- (Video*)initWithTitle:(NSString*)strTitle withURL:(NSString*)strURL withWebUrl:(NSString*)strWebUrl;

@end
