//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Eli Ganem. All rights reserved.
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

@end
