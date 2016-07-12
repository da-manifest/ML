//
//  HorizontalScroll.m
//  ML
//
//  Created by Admin on 11/07/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "HorizontalScroll.h"

#define VIEW_PADDIND 10
#define VIEW_DIMENSIONS 100
#define VIEW_OFFSET 100

@interface HorizontalScroll() <UIScrollViewDelegate>

@end

@implementation HorizontalScroll
{
    UIScrollView *scroll;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroll.delegate = self;
        [self addSubview:scroll];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTapped:)];
        [scroll addGestureRecognizer:tapRecognizer];
    }
    return self;
}

-(void)scrollTapped:(UIGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    for (int index = 0; index < [self.delegate numberOfViewsForHorizontalScroll:self]; index++)
    {
        UIView *view = scroll.subviews[index];
        if (CGRectContainsPoint(view.frame, location))
        {
            [self.delegate horizontalScroll:self clickedViewAtIndex:index];
            CGPoint offset = CGPointMake(view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2, 0);
            [scroll setContentOffset:offset animated:true];
            break;
        }
    }
}

-(void) centerCurrentView
{
    int xFinal = scroll.contentOffset.x + VIEW_OFFSET / 2 + VIEW_PADDIND;
    int viewIndex = xFinal / (VIEW_DIMENSIONS + 2 * VIEW_PADDIND);
    xFinal = viewIndex * (VIEW_DIMENSIONS + 2 * VIEW_PADDIND);
    [scroll setContentOffset:CGPointMake(xFinal, 0) animated:true];
    [self.delegate horizontalScroll:self clickedViewAtIndex:viewIndex];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) [self centerCurrentView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
}

-(void)reload
{
    if (self.delegate == nil) return;
    
    [scroll.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [obj removeFromSuperview];
     }];
    
    CGFloat xValue = VIEW_OFFSET;
    for (int i = 0; i < [self.delegate numberOfViewsForHorizontalScroll:self]; i++)
    {
        xValue += VIEW_PADDIND;
        UIView *view = [self.delegate horizontalScroll:self viewAtIndex:i];
        view.frame = CGRectMake(xValue, VIEW_PADDIND, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
        [scroll addSubview:view];
        xValue += VIEW_DIMENSIONS + VIEW_PADDIND;
    }
    
    [scroll setContentSize:CGSizeMake(xValue + VIEW_OFFSET, self.frame.size.height)];
    
    if ([self.delegate respondsToSelector:@selector(startViewIndexForHorizontalScroll:)])
    {
        int startView = [self.delegate startViewIndexForHorizontalScroll:self];
        CGPoint offset = CGPointMake(startView * (VIEW_DIMENSIONS + 2 * VIEW_PADDIND), 0);
        [scroll setContentOffset:offset animated:true];
    }
}

-(void) didMoveToSuperview
{
    [self reload];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
