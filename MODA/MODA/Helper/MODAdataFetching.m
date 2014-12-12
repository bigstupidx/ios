//
//  MODAdataFetching.m
//  MODA
//
//  Created by Macbook Pro on 1/10/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "MODAdataFetching.h"
#import "Article.h"
#import "MSAdvers.h"
#import "Album.h"
#import "Photo.h"
#import "Video.h"
#import "ZMFMDBSQLiteHelper.h"

@implementation MODAdataFetching
{
    int downloadCount;
}

- (void)articleDownloadWithHTTP:(NSString*)pathStr withKey:(NSString*)dictKey
{
    self.isArticleError = NO;
    self.isArticleMaxoffset = NO;
    
//    NSMutableArray* articleArr = [[NSMutableArray alloc] init];
    NSString* adsPath = pathStr;
    NSURL *url = [NSURL URLWithString:adsPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             if ([dict objectForKey:@"maxoffset"]) {
                 self.isArticleMaxoffset = YES;
             }
             else {
                 
                 NSArray* articles = [dict objectForKey:dictKey]; //@"beauty_list"
                 [self insertArticleIntoDBWithTableName:dictKey fromArray:articles];
             }
             
             
             }
//         }
         else {
             self.isArticleError = YES;
         }
//         [self finishedDownloading];
         if (self.isMoreArticleDownload) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedMoreArticleDownload" object:self];
             self.isMoreArticleDownload = NO;
         }
         else {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedArticleDownload" object:self];
         }
         
     }];
}

- (void)adsDownloading
{
//    NSMutableArray* adsArr = [[NSMutableArray alloc] init];
//    NSMutableArray* adsHomeArr = [[NSMutableArray alloc] init];
    NSString* adsPath = @"http://www.moda.com.mm/mobile/adver_list";
    NSURL *url = [NSURL URLWithString:adsPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSArray* ads = [dict objectForKey:@"adver_list"];
             [self insertAdsToDBWithArray:ads];             
             
         }
         else {
//             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ads Download Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//             [alert show];
         }
//         [self finishedDownloading];
    }];
}

- (void)galleryDownloadingWithLimit:(int)limit
{
    self.isGalleryMaxOffset = NO;
    self.isGalleryError = NO;
    
//    NSMutableArray* albumArr = [[NSMutableArray alloc] init];
    
    NSString* adsPath = [NSString stringWithFormat:@"http://www.moda.com.mm/mobile/gallery_list?offset=1&limit=%d",limit]; //www.moda.com.mm
    NSURL *url = [NSURL URLWithString:adsPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             if ([dict objectForKey:@"maxoffset"]) {
                 self.isGalleryMaxOffset = YES;
             }
             else {
                 NSArray* galleryArr = [dict objectForKey:@"gallery_list"];
                 
                 [self insertGalleryListWithArray:galleryArr];
             }

         }
         else {
             
//             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Album Download Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//             [alert show];
             self.isGalleryError = YES;
         }
         
         //[self finishedDownloading];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGalleryDownload" object:self];
     }];

}

- (void)videoListDownloadingWithLimit:(int)limit
{
    self.isVideoError = NO;
    self.isVideoMaxOffset = NO;
//    NSMutableArray* mulArr = [[NSMutableArray alloc] init];
    
    NSString* adsPath = [NSString stringWithFormat:@"http://www.moda.com.mm/mobile/video_list?offset=1&limit=%d",limit];
    NSURL *url = [NSURL URLWithString:adsPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             if ([dict objectForKey:@"maxoffset"]) {
                 self.isVideoMaxOffset = YES;
             }
             else {
                 NSArray* videoArr = [dict objectForKey:@"video_list"];
                 
                 [self insertVideoListWithArray:videoArr];
             }
            
         }
         else {
             self.isVideoError = YES;
         }
         //[self finishedDownloading];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedVideoDownload" object:self];
     }];
}

- (void)finishedDownloading
{
    //self.count
    downloadCount += 1;
    NSLog(@"Download Count = %d", downloadCount);
    if (downloadCount == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishArticlesDownload" object:self];
    } //6
}


- (void) insertArticleIntoDBWithTableName:(NSString*)table fromArray:(NSArray*)array
{
    ZMFMDBSQLiteHelper *db = [[ZMFMDBSQLiteHelper alloc] init];
    if (array.count > 0) {
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",table]];
    }
    
    for (NSDictionary* dict in array) {
        NSMutableString *insert_query = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", table];
        
        [insert_query appendFormat:@"id, title, type, description, image_url, video, issue, status, web_url) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",[dict objectForKey:@"id"],[dict objectForKey:@"title"],[dict objectForKey:@"type"],[dict objectForKey:@"description"],[dict objectForKey:@"image_url"],[dict objectForKey:@"video"], [dict objectForKey:@"issue"],[dict objectForKey:@"status"], [dict objectForKey:@"web_url"]];
        
        [db executeQuery:insert_query];
        
        NSArray* galleryArr = [dict objectForKey:@"gallery"];
        if (galleryArr.count > 0) {
            [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM gallery where id = '%@'",[dict objectForKey:@"id"]]];
        }
        for (NSDictionary* galleryDict in galleryArr) {
            NSMutableString* galleryInsert = [NSMutableString stringWithFormat:@"INSERT INTO %@ (",@"gallery"];
            
            [galleryInsert appendFormat:@"id, gallery_img_url) VALUES ('%@', '%@')",[dict objectForKey:@"id"],[galleryDict objectForKey:@"gallery_img_url"]];
            [db executeQuery:galleryInsert];
        }
        
        NSArray* videoArr = [dict objectForKey:@"video_url"];
        if (videoArr.count > 0) {
            [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM video_url where id = '%@'",[dict objectForKey:@"id"]]];
        }
        
        for (NSDictionary* videoDict in videoArr) {
            NSMutableString* videoInsert = [NSMutableString stringWithFormat:@"INSERT INTO %@ (",@"video_url"];
            
            [videoInsert appendFormat:@"url, video_description, id) VALUES ('%@', '%@', '%@')",[videoDict objectForKey:@"url"],[videoDict objectForKey:@"video_description"], [dict objectForKey:@"id"]];
            [db executeQuery:videoInsert];
        }
    }
}

- (void) insertAdsToDBWithArray:(NSArray*)adsArr
{
    ZMFMDBSQLiteHelper *db = [[ZMFMDBSQLiteHelper alloc] init];
    if (adsArr.count > 0) {
        [db executeUpdate:@"DELETE FROM adver_list"];
    }
    
    for (NSDictionary* dict in adsArr) {
        NSMutableString *insert_query = [NSMutableString stringWithFormat:@"INSERT INTO adver_list (adver_id, image_url, position, status, website_url) VALUES ('%@', '%@', '%@', '%@', '%@')",[dict objectForKey:@"adver_id"], [dict objectForKey:@"image_url"], [dict objectForKey:@"position"], [dict objectForKey:@"status"], [dict objectForKey:@"website_url"]];
        [db executeQuery:insert_query];
    }
}

- (void) insertGalleryListWithArray:(NSArray*)galleryArr
{
    ZMFMDBSQLiteHelper *db = [[ZMFMDBSQLiteHelper alloc] init];
    if (galleryArr.count > 0) {
        [db executeUpdate:@"DELETE FROM gallery_list"];
    }
    
    for (NSDictionary* dict in galleryArr) {
        NSMutableString *insert_query = [NSMutableString stringWithFormat:@"INSERT INTO gallery_list (id, title, image_url, issue) VALUES ('%@', '%@', '%@', '%@')",[dict objectForKey:@"id"], [dict objectForKey:@"title"], [dict objectForKey:@"image_url"], [dict objectForKey:@"issue"]];
        [db executeQuery:insert_query];
        
        NSArray* gallerylist = [dict objectForKey:@"gallery"];
        if (gallerylist.count > 0) {
            [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM gallery_list_gallery where id = '%@'",[dict objectForKey:@"id"]]];
        }
        for (NSDictionary* galleryDict in gallerylist) {
            NSMutableString *insert_query1 = [NSMutableString stringWithFormat:@"INSERT INTO gallery_list_gallery (id, imagename) VALUES ('%@', '%@')",[dict objectForKey:@"id"], [galleryDict objectForKey:@"imagename"]];
            [db executeQuery:insert_query1];
        }
    }
}

- (void) insertVideoListWithArray:(NSArray*)videoArr
{
    ZMFMDBSQLiteHelper *db = [[ZMFMDBSQLiteHelper alloc] init];
    if (videoArr.count > 0) {
        [db executeUpdate:@"DELETE FROM video_list"];
    }
    
    for (NSDictionary* dict in videoArr) {
        NSMutableString *insert_query = [NSMutableString stringWithFormat:@"INSERT INTO video_list (id, title, video_url, issue, web_url) VALUES ('%@', '%@', '%@', '%@', '%@')",[dict objectForKey:@"id"], [dict objectForKey:@"title"], [dict objectForKey:@"video_url"], [dict objectForKey:@"issue"],[dict objectForKey:@"web_url"]];
        [db executeQuery:insert_query];
        
    }
}

@end
