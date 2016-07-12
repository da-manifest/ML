//
//  MyAlbum+TableRepresentation.m
//  ML
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "MyAlbum+TableRepresentation.h"

@implementation MyAlbum (TableRepresentation)

-(NSDictionary *)tr_tableRepresentation
{
    return @{@"titles":@[@"Исполнитель", @"Альбом", @"Жанр", @"Год"],
             @"values":@[self.artist, self.title, self.genre, self.year]};
}

@end
