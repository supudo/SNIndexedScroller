//
//  SNScrollableItem.h
//  SNIndexedScroller
//
//  Created by Sergey Petrov on 9/17/13.
//  Copyright (c) 2013 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNScrollableItemDelegate <NSObject>
@optional
- (void)draggedUp:(id)sender diff:(float)px;
- (void)draggedDown:(id)sender diff:(float)px;
@end

@interface SNScrollableItem : UIView

@property (assign) id<SNScrollableItemDelegate> delegate;

@end
