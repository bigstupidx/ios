//
//  Album.h
//  Moda
//
//  Created by Zune Moe on 2/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;

@interface Album : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *photos;

- (void)addPhoto:(Photo *)photo;
- (BOOL)removePhoto:(Photo *)photo;

- (Album*)initWithName:(NSString*)title withPhotos:(NSArray*)fotos;
@end
