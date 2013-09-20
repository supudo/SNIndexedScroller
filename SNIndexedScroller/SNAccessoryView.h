//
//  SNAccessoryView.h
//  SNIndexedScroller
//
//  Created by Sergey Petrov on 9/17/13.
//  Copyright (c) 2013 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNAccessoryView : UIView

@property (nonatomic, readwrite) CGFloat arrowWidth;
@property (nonatomic, readwrite, retain) UIColor *foregroundColor;
@property (nonatomic, readwrite) UIEdgeInsets labelEdgeInsets;
@property (nonatomic, readonly) UILabel *lblText;
@property float viewWidth;

@end
