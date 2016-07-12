//
//  DataManager.m
//  ML
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()
{
    NSMutableArray *albums;
}
@end

@implementation DataManager

-(id)init
{
    self = [super init];
    if (self)
    {
        albums = [NSMutableArray arrayWithArray:
  @[[[MyAlbum alloc] initWithTitle:@"Best of Bowie" andArtist:@"Dawid Bowie" andGenre:@"Pop" andCoverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_david_bowie_best_of_bowie.png" andYear:@"1992"],
    
    [[MyAlbum alloc] initWithTitle:@"It's My Life" andArtist:@"No Doubt" andGenre:@"Rock" andCoverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_no_doubt_its_my_life_bathwater.png" andYear:@"2003"],
    
    [[MyAlbum alloc] initWithTitle:@"Nothing Like The Sun" andArtist:@"Sting" andGenre:@"Folk" andCoverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_sting_nothing_like_the_sun.png" andYear:@"1999"],
    
    [[MyAlbum alloc] initWithTitle:@"Staring at the Sun" andArtist:@"U2" andGenre:@"Jazz" andCoverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_u2_staring_at_the_sun.png" andYear:@"2000"],
    
    [[MyAlbum alloc] initWithTitle:@"American Pie" andArtist:@"Madonna" andGenre:@"Pop" andCoverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_madonna_american_pie.png" andYear:@"2000"]]];
    }
    return self;
}

-(NSArray *) albums
{
    return albums;
}

-(void)addAlbum:(MyAlbum *)album atIndex:(NSUInteger)index
{
    if (albums.count >= index)
        [albums insertObject:album atIndex:index];
    else
        [albums addObject:album];
}

-(void)deleteAlbumAtIndex:(NSUInteger)index
{
    [albums removeObjectAtIndex:index];
}

-(void)saveImage:(UIImage *)image toFile:(NSString *)fileName
{
    fileName = [NSHomeDirectory() stringByAppendingFormat:@"Documents/Cover Images/%@", fileName];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:fileName atomically:true];
}

-(UIImage *)getImageFromFile:(NSString *)fileName
{
    fileName = [NSHomeDirectory()  stringByAppendingFormat:@"Documents/Cover Images/%@", fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName]) {
        NSData *data = [NSData dataWithContentsOfFile:fileName];
        return [UIImage imageWithData:data];
    }
    return nil;
}

@end
