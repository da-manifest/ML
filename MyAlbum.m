//
//  MyAlbum.m
//  ML
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Admin. All rights reserved.
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

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.artist forKey:@"artist"];
    [aCoder encodeObject:self.genre forKey:@"genre"];
    [aCoder encodeObject:self.coverUrl forKey:@"coverUrl"];
    [aCoder encodeObject:self.year forKey:@"year"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _artist = [aDecoder decodeObjectForKey:@"artist"];
        _genre = [aDecoder decodeObjectForKey:@"genre"];
        _coverUrl = [aDecoder decodeObjectForKey:@"coverUrl"];
        _year = [aDecoder decodeObjectForKey:@"year"];
    }
    return self;
}

@end
