//
//  HorizontalScroll.h
//  ML
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollDelegate;

@interface HorizontalScroll : UIView

@property (weak) id<HorizontalScrollDelegate> delegate;

-(void) reload;

@end

@protocol HorizontalScrollDelegate <NSObject>

@required

-(NSInteger)numberOfViewsForHorizontalScroll:(HorizontalScroll *)scroll;
-(UIView *)horizontalScroll:(HorizontalScroll *)scroll viewAtIndex:(int)index;
-(void)horizontalScroll:(HorizontalScroll *)scroll clickedViewAtIndex:(int)index;

@optional

-(NSInteger)startViewIndexForHorizontalScroll:(HorizontalScroll *)scroll;

@end
