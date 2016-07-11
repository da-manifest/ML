//
//  DataManager.h
//  BlueLibrary
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAlbum.h"

@interface DataManager : NSObject

-(NSArray *) albums;
-(void)addAlbum:(MyAlbum *)album atIndex:(NSUInteger)index;
-(void)deleteAlbumAtIndex:(NSUInteger)index;

@end
