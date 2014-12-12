//
//  Album.m
//  Moda
//
//  Created by Zune Moe on 2/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "Album.h"
#import "Photo.h"

@interface Album ()
@property (nonatomic, strong) NSMutableArray *mutablePhotos;
@end

@implementation Album

#pragma mark - Properties

//- (NSArray *)photos
//{
//    return [self.mutablePhotos copy];
//}

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.mutablePhotos = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Photos

- (void)addPhoto:(Photo *)photo
{
    [self.mutablePhotos addObject:photo];
}

- (BOOL)removePhoto:(Photo *)photo
{
    if ([self.mutablePhotos indexOfObject:photo] == NSNotFound) {
        return NO;
    }
    
    [self.mutablePhotos removeObject:photo];
    
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"albumName"];
    [encoder encodeObject:self.photos forKey:@"albumPhoto"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"albumName"];
        self.photos = [decoder decodeObjectForKey:@"albumPhoto"];
    }
    return self;
}

//initWithName and Photos
- (Album*)initWithName:(NSString*)title withPhotos:(NSArray*)fotos
{
    self = [super init];
    if (self) {
        self.name = title;
        self.photos = fotos;
    }
    return self;
}

@end
