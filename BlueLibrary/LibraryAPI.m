//
//  LibraryAPI.m
//  ML
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "LibraryAPI.h"
#import "DataManager.h"
#import "HTTPClient.h"

@interface LibraryAPI()
{
    DataManager *dataManager;
    HTTPClient *httpClient;
    BOOL isOnline;
}
@end

@implementation LibraryAPI

-(id)init
{
    self = [super init];
    if (self)
    {
        dataManager = [DataManager new];
        httpClient = [HTTPClient new];
        isOnline = false;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification" object:nil];
    }
    return self;
}

+(LibraryAPI *) sharedInstance
{
    static LibraryAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once (&oncePredicate, ^{
        _sharedInstance = [LibraryAPI new];
    });
        return _sharedInstance;
}

-(NSArray *) albums
{
    return [dataManager albums];
}

-(void)addAlbum:(MyAlbum *)album atIndex:(NSUInteger)index
{
    [dataManager addAlbum:album atIndex:index];
    if (isOnline)
    {
        [httpClient postRequest:@"api/addAlbum" body:[album description]];
    }
}

-(void)deleteAlbumAtIndex:(NSUInteger)index
{
    [dataManager deleteAlbumAtIndex:index];
    if (isOnline) {
        [httpClient postRequest:@"api/deleteAlbum" body:[@(index) description]];
    }
}

-(void)downloadImage:(NSNotification *)notification
{
    NSString *coverUrl = notification.userInfo[@"coverUrl"];
    UIImageView *imageView = notification.userInfo[@"imageView"];
    imageView.image = [dataManager getImageFromFile:[coverUrl lastPathComponent]];
    if (imageView.image == nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{UIImage *image = [httpClient downloadImage:coverUrl];
                           dispatch_sync(dispatch_get_main_queue(),
                                         ^{imageView.image = image;
                               [dataManager saveImage:image toFile:[coverUrl lastPathComponent]];
                                         });
                       });
    }
    
    
}

-(void)saveMyAlbums
{
    [dataManager saveMyAlbums];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
