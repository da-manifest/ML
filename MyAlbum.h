//
//  MyAlbum.h
//  ML
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAlbum : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *artist;
@property (nonatomic, copy, readonly) NSString *genre;
@property (nonatomic, copy, readonly) NSString *coverUrl;
@property (nonatomic, copy, readonly) NSString *year;

-(id) initWithTitle:(NSString *)title andArtist:(NSString *)artist andGenre:(NSString *)genre andCoverUrl: (NSString *)coverUrl andYear:(NSString *)year;

@end
