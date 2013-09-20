//
//  ViewController.m
//  SNIndexedScroller
//
//  Created by Sergey Petrov on 9/17/13.
//  Copyright (c) 2013 supudo.net. All rights reserved.
//

#import "ViewController.h"
#import "SNScrollView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SNScrollView *sv = [[SNScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [sv setupSectionID:@"section"];
    [sv setColorScroller:[UIColor blackColor] withAlpha:.2f];
    [sv setColorSectionDot:[UIColor blackColor] withAlpha:1.0f];
    [sv setColorAccessoryView:[UIColor darkGrayColor] withAlpha:1.0f];
    [sv setFontAccessoryView:[UIFont boldSystemFontOfSize:16] withColor:[UIColor whiteColor]];
    [sv showContentWithFile:@"content.txt"];
    [self.view addSubview:sv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
