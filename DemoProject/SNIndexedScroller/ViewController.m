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
    [sv setColorScroller:[UIColor greenColor] withAlpha:.8f];
    [sv setColorSectionDot:[UIColor redColor] withAlpha:1];
    [sv setColorAccessoryView:[UIColor blueColor] withAlpha:1];
    [sv setFontAccessoryView:[UIFont boldSystemFontOfSize:16] withColor:[UIColor redColor]];
    [sv showContentWithFile:@"content.txt"];
    [self.view addSubview:sv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
