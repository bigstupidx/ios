//
//  UIColor+Utilities.m
//  KamayutMedia
//
//  Created by Zune Moe on 2/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "UIColor+Utilities.h"

@implementation UIColor (Utilities)
+(UIColor *)colorFromRGBHexString:(NSString *)colorString{
    if(colorString.length == 7) {
        const char *colorUTF8String = [colorString UTF8String];
        int r, g, b;
        sscanf(colorUTF8String, "#%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0];
    }
    return nil;
}
@end
