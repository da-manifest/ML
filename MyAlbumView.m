//
//  MyAlbumView.m
//  BlueLibrary
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Eli Ganem. All rights reserved.
//

#import "MyAlbumView.h"

@implementation MyAlbumView
{
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

-(id) initWithFrame:(CGRect)frame andAlbumCover:(NSString *)albumCover
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
        [self addSubview:coverImage];
        
        indicator = [UIActivityIndicatorView new];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [indicator stopAnimating];
        [self addSubview:indicator];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end