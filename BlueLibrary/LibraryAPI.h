//
//  LibraryAPI.h
//  ML
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAlbum.h"

@interface LibraryAPI : NSObject

+(LibraryAPI *)sharedInstance;

-(NSArray *) albums;
-(void)addAlbum:(MyAlbum *)album atIndex:(NSUInteger)index;
-(void)deleteAlbumAtIndex:(NSUInteger)index;
-(void)saveMyAlbums;

@end
