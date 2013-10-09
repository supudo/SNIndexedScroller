//
//  SNScrollableItem.m
//  SNIndexedScroller
//
//  Created by Sergey Petrov on 9/17/13.
//  Copyright (c) 2013 supudo.net. All rights reserved.
//

#import "SNScrollableItem.h"
#import <QuartzCore/QuartzCore.h>

@interface SNScrollableItem ()
@property CGFloat previousPositionY;
@end

@implementation SNScrollableItem

@synthesize delegate, previousPositionY;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.3];
        [self.layer setCornerRadius:5];
        [self.layer setMasksToBounds:YES];
        previousPositionY = 0;
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    
    [UIView beginAnimations:@"Dragging Scoller" context:nil];

    float scrollHeight = [self superview].frame.size.height - self.frame.size.height;
    float y = location.y;
    if (y < self.frame.size.height)
        y = 10;
    if (y > scrollHeight)
        y = scrollHeight;
    // Issue #1 fix
    ///~self.frame = CGRectMake(1, y, self.frame.size.width, self.frame.size.height);

    [UIView commitAnimations];

    if (self.delegate != nil) {
        if (previousPositionY < y && [self.delegate respondsToSelector:@selector(draggedDown:diff:)])
            [self.delegate draggedDown:self diff:y];
        if (previousPositionY > y && [self.delegate respondsToSelector:@selector(draggedUp:diff:)])
            [self.delegate draggedUp:self diff:y];
    }
    previousPositionY = y;
}

@end
