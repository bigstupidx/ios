//
//  Photo.m
//  Moda
//
//  Created by Zune Moe on 2/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "Photo.h"

@interface Photo ()
@property (nonatomic, strong, readwrite) NSURL *imageURL;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *description;
@property (nonatomic, strong, readwrite) NSURL *postURL;
@end

@implementation Photo

#pragma mark - Properties

- (UIImage *)image
{
    if (!_image && self.imageURL) {
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        UIImage *image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        
        _image = image;
    }
    
    return _image;
}

#pragma mark - Lifecycle

+ (Photo *)photoWithImageURL:(NSURL *)imageURL title:(NSString *)title description:(NSString *)description postURL:(NSURL *)postURL
{
    return [[self alloc] initWithImageURL:imageURL title:title description:description postURL:postURL];
}

- (id)initWithImageURL:(NSURL *)imageURL title:(NSString *)title description:(NSString *)description postURL:(NSURL *)postURL
{
    self = [super init];
    if (self) {
        self.imageURL = imageURL;
        self.title = title;
        self.description = description;
        self.postURL = postURL;
    }
    return self;
}

- (Photo*)initWithImageUrl:(NSURL*)imgUrl
{
    self = [super init];
    if (self) {
        self.imageURL = imgUrl;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.description forKey:@"description"];
    [encoder encodeObject:self.postURL forKey:@"postURL"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.description = [decoder decodeObjectForKey:@"description"];
        self.postURL = [decoder decodeObjectForKey:@"postURL"];
    }
    return self;
}
@end
