//
//  MSAdvers.m
//  MMJunction
//
//  Created by Macbook Pro on 9/18/13.
//  Copyright (c) 2013 Ignite Software Solutions. All rights reserved.
//

#import "MSAdvers.h"

@implementation MSAdvers

@synthesize adsUrl;
@synthesize adsPosition;

- (MSAdvers*)initWithAdsUrl:(NSString*)adsURL withPosition:(NSString*)adsPos withWebURL:(NSString *)adswebUrl
{
    self.adsUrl = adsURL;
    self.adsPosition = adsPos;
    self.adsWeburl = adswebUrl;
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.adsUrl forKey:@"adsUrl"];
    [encoder encodeObject:self.adsPosition forKey:@"adsPosition"];
    //[encoder encodeObject:self.adsStatus forKey:@"status"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
        self.adsUrl = [decoder decodeObjectForKey:@"adsUrl"];
        self.adsPosition = [decoder decodeObjectForKey:@"adsPosition"];
        //self.adsStatus = [decoder decodeObjectForKey:@"status"];
    }
    return self;
}

@end
