//
//  Article.m
//  Moda
//
//  Created by Zune Moe on 2/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "Article.h"

@implementation Article

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.articleAuthor forKey:@"articleAuthor"];
    [encoder encodeObject:self.articleDate forKey:@"articleDate"];
    [encoder encodeObject:self.articleDetails forKey:@"articleDetails"];
    [encoder encodeObject:self.articlePhoto forKey:@"articlePhoto"];
    [encoder encodeObject:self.articleTitle forKey:@"articleTitle"];
    [encoder encodeObject:self.articleSubCat forKey:@"articleSubCat"];
    [encoder encodeObject:self.articleGallery forKey:@"articleGallery"];
    [encoder encodeObject:self.articleImgUrl forKey:@"articleImgUrl"];
    [encoder encodeObject:self.articleVideo forKey:@"articleVideo"];
    [encoder encodeObject:self.articleVideoUrl forKey:@"articleVideoUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
        self.articleAuthor = [decoder decodeObjectForKey:@"articleAuthor"];
        self.articleDate = [decoder decodeObjectForKey:@"articleDate"];
        self.articleDetails = [decoder decodeObjectForKey:@"articleDetails"];
        self.articlePhoto = [decoder decodeObjectForKey:@"articlePhoto"];
        self.articleTitle = [decoder decodeObjectForKey:@"articleTitle"];
        self.articleSubCat = [decoder decodeObjectForKey:@"articleSubCat"];
        self.articleGallery = [decoder decodeObjectForKey:@"articleGallery"];
        self.articleImgUrl = [decoder decodeObjectForKey:@"articleImgUrl"];
        self.articleVideo = [decoder decodeObjectForKey:@"articleVideo"];
        self.articleVideoUrl = [decoder decodeObjectForKey:@"articleVideoUrl"];
    }
    return self;
}

- (Article*)initWithTitle:(NSString*)arTitle withDetails:(NSString*)arDesc withSubCat:(NSString*)arType withImgUrl:(NSString*)arImgUrl withVideo:(NSString*)arVideo withVideoUrl:(NSArray*)arVideoUrl withGallery:(NSArray*)arGallery
{
    self.articleTitle = arTitle;
    self.articleDetails = arDesc;
    self.articleSubCat = arType;
    self.articleImgUrl = arImgUrl;
    self.articleVideo = arVideo;
    self.articleVideoUrl = arVideoUrl;
    self.articleGallery = arGallery;
    
    return self;
}

@end
