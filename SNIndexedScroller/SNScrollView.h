//
//  SNScrollView.h
//  SNIndexedScroller
//
//  Created by Sergey Petrov on 9/18/13.
//  Copyright (c) 2013 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNScrollableItem.h"

@interface SNScrollView : UIView <UIScrollViewDelegate, UIWebViewDelegate, SNScrollableItemDelegate>

// Show content from file
- (void)showContentWithFile:(NSString *)filename;

// Show content from string
- (void)showContentWithString:(NSString *)content;

// Set section ID tag labels throughout the content document
- (void)setupSectionID:(NSString *)sectionid;

// Set scroller color with alpha
- (void)setColorScroller:(UIColor *)color withAlpha:(float)alpha;

// Set section dot color with alpha
- (void)setColorSectionDot:(UIColor *)color withAlpha:(float)alpha;

// Set accessory view color with alpha
- (void)setColorAccessoryView:(UIColor *)color withAlpha:(float)alpha;

// Set accessory view font & color
- (void)setFontAccessoryView:(UIFont *)font withColor:(UIColor *)color;

@end
