//
//  Video.m
//  MODA
//
//  Created by Macbook Pro on 1/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "Video.h"

@implementation Video

- (Video*)initWithTitle:(NSString*)strTitle withURL:(NSString*)strURL withWebUrl:(NSString *)strWebUrl
{
    self = [super init];
    if (self) {
        self.vtitle = strTitle;
        self.vUrl = strURL;
        self.vWebUrl = strWebUrl;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.vtitle forKey:@"vtitle"];
    [encoder encodeObject:self.vUrl forKey:@"vUrl"];
    //[encoder encodeObject:self.adsStatus forKey:@"status"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
        self.vtitle = [decoder decodeObjectForKey:@"vtitle"];
        self.vUrl = [decoder decodeObjectForKey:@"vUrl"];
        //self.adsStatus = [decoder decodeObjectForKey:@"status"];
    }
    return self;
}

@end
