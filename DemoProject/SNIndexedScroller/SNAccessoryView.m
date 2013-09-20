//
//  SNAccessoryView.m
//  SNIndexedScroller
//
//  Created by Sergey Petrov on 9/17/13.
//  Copyright (c) 2013 supudo.net. All rights reserved.
//

#import "SNAccessoryView.h"

@interface SNAccessoryView ()
@property (nonatomic, strong) UILabel *lblText;
@end

@implementation SNAccessoryView

@synthesize arrowWidth;
@synthesize foregroundColor = _foregroundColor;
@synthesize labelEdgeInsets = _labelEdgeInsets;
@synthesize lblText;
@synthesize viewWidth;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setOpaque:NO];

        arrowWidth = 20;
        _foregroundColor = [UIColor clearColor];
        _labelEdgeInsets = UIEdgeInsetsMake(1, 6, 1, 6);
        
        lblText = [[UILabel alloc] initWithFrame:CGRectZero];
        [lblText setBackgroundColor:_foregroundColor];
        [lblText setTextColor:[UIColor whiteColor]];
        [lblText setFont:[UIFont systemFontOfSize:14]];
        [lblText setLineBreakMode:NSLineBreakByWordWrapping];
        [lblText setNumberOfLines:0];
        [lblText setUserInteractionEnabled:NO];
        [self addSubview:lblText];
        
        [self setBackgroundColor:self.foregroundColor];
        [self.layer setCornerRadius:8];
        [self.layer setMasksToBounds:YES];
    }
    return self;
}

- (UILabel *)lblText {
    return lblText;
}

- (void)setLblText:(UITextView *)lblText {
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [lblText setFrame:UIEdgeInsetsInsetRect([self bounds], _labelEdgeInsets)];
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, bounds.size.width - arrowWidth, 0);

    CGPathAddLineToPoint(path, NULL, bounds.size.width, bounds.size.height / 2 - 1);
    CGPathAddLineToPoint(path, NULL, bounds.size.width - arrowWidth, bounds.size.height);

    CGPathAddLineToPoint(path, NULL, 0, bounds.size.height);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [[self foregroundColor] CGColor]);
    CGContextFillPath(context);
    
    CGPathRelease(path);
}

@end
