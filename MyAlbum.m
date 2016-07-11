//
//  MyAlbum.m
//  BlueLibrary
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Eli Ganem. All rights reserved.
//

#import "MyAlbum.h"

@implementation MyAlbum

-(id) initWithTitle:(NSString *)title andArtist:(NSString *)artist andGenre:(NSString *)genre andCoverUrl: (NSString *)coverUrl andYear:(NSString *)year
{
    self = [super init];
    if (self)
    {
        _title = title;
        _artist = artist;
        _genre = genre;
        _coverUrl = coverUrl;
        _year = year;
    }
    return self;
}

@end
