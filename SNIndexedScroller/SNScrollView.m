//
//  SNScrollView.m
//  SNIndexedScroller
//
//  Created by Sergey Petrov on 9/18/13.
//  Copyright (c) 2013 supudo.net. All rights reserved.
//

#import "SNScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "SNAccessoryView.h"

@interface SNScrollView ()
@property (nonatomic, strong) UIScrollView *viewContent;
@property (nonatomic, strong) UIWebView *viewWeb;
@property (nonatomic, strong) UIView *viewScroller;

@property float contentHeight, scrollbarWidth;
@property CGFloat firstX, firstY;
@property int sectionCount;
@property (nonatomic, strong) SNScrollableItem *scrollingItem;
@property (nonatomic, strong) SNAccessoryView *scrollingAccessoryView;
@property (nonatomic, strong) NSMutableArray *listSections, *listSectionIDs;
@property (nonatomic, strong) NSString *currentContent, *sectionTitleTag;
@property (nonatomic, strong) UIColor *colorDefaultScroller, *colorDefaultSectionDot, *colorDefaultAccessoryView, *colorDefaultAccessoryViewText;
@property (nonatomic, strong) UIFont *fontSectionTitle;
@end

@implementation SNScrollView

@synthesize viewContent, viewWeb, viewScroller, contentHeight, firstX, firstY, scrollingItem;
@synthesize scrollingAccessoryView, scrollbarWidth, sectionTitleTag, fontSectionTitle;
@synthesize colorDefaultScroller, colorDefaultSectionDot, colorDefaultAccessoryView, colorDefaultAccessoryViewText;

#pragma mark - Public methods

- (void)showContentWithFile:(NSString *)filename {
    NSString *pathTemplate = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
    NSString *textTemplate = [NSString stringWithContentsOfFile:pathTemplate encoding:NSUTF8StringEncoding error:nil];
    NSString *pathContent = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
    NSString *textContent = [NSString stringWithContentsOfFile:pathContent encoding:NSUTF8StringEncoding error:nil];
    self.currentContent = [textTemplate stringByReplacingOccurrencesOfString:@"{CONTENT}" withString:textContent];
    [self showContentWithString:self.currentContent];
}

- (void)showContentWithString:(NSString *)content {
    self.currentContent = content;
    [self extractDocumentSections];
}

- (void)setupSectionID:(NSString *)sectionid {
    self.sectionTitleTag = sectionid;
}

- (void)setColorScroller:(UIColor *)color withAlpha:(float)alpha {
    self.colorDefaultScroller = [self colorInjectAlpha:color withAlpha:alpha];
    if (self.viewScroller != nil)
        [self.viewScroller setBackgroundColor:color];
}

- (void)setColorSectionDot:(UIColor *)color withAlpha:(float)alpha {
    self.colorDefaultSectionDot = [self colorInjectAlpha:color withAlpha:alpha];
}

- (void)setColorAccessoryView:(UIColor *)color withAlpha:(float)alpha {
    self.colorDefaultAccessoryView = [self colorInjectAlpha:color withAlpha:alpha];
}

- (void)setFontAccessoryView:(UIFont *)font withColor:(UIColor *)color {
    self.fontSectionTitle = font;
    self.colorDefaultAccessoryViewText = color;
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Scrollbar width
        self.scrollbarWidth = 20;
        
        // Sections in the document
        self.sectionCount = 0;
        
        // Default colors & fonts
        self.colorDefaultScroller = [UIColor orangeColor];
        self.colorDefaultSectionDot = [UIColor whiteColor];
        self.colorDefaultAccessoryView = [UIColor colorWithWhite:0.2f alpha:.8f];
        self.fontSectionTitle = [UIFont fontWithName:@"System" size:14];
        self.colorDefaultAccessoryViewText = [UIColor whiteColor];

        // Scroll view for the UIWebView content
        self.viewContent = [[UIScrollView alloc] init];
        [self.viewContent setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width - self.scrollbarWidth, frame.size.height)];
        [self.viewContent setDelegate:self];
        [self.viewContent setScrollEnabled:YES];
        [self.viewContent setShowsHorizontalScrollIndicator:NO];
        [self.viewContent setShowsVerticalScrollIndicator:NO];
        [self.viewContent setBounces:NO];
        [self.viewContent setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.viewContent setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.viewContent];
        
        // The web view that will show the HTML content
        self.viewWeb = [[UIWebView alloc] init];
        [self.viewWeb setFrame:self.viewContent.frame];
        [self.viewWeb setDelegate:self];
        [self.viewWeb setDataDetectorTypes:UIDataDetectorTypeNone];
        [self.viewWeb setUserInteractionEnabled:NO];
        [self.viewWeb setBackgroundColor:[UIColor clearColor]];
        [self.viewWeb setOpaque:NO];
        [self.viewWeb.scrollView setBounces:NO];
        [self.viewWeb.scrollView setScrollEnabled:NO];
        [self.viewContent addSubview:self.viewWeb];
        
        // The scrollbar view
        self.viewScroller = [[UIView alloc] init];
        [self.viewScroller setFrame:CGRectMake(frame.size.width - self.scrollbarWidth, frame.origin.y, self.scrollbarWidth, frame.size.height)];
        [self.viewScroller setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.viewScroller setBackgroundColor:self.colorDefaultScroller];
        [self addSubview:self.viewScroller];
        
        self.listSections = [[NSMutableArray alloc] init];
        self.listSectionIDs = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Loading

- (void)extractDocumentSections {
    NSString *searchTag = [NSString stringWithFormat:@"id=\"%@", self.sectionTitleTag];
    NSRange searchRange = NSMakeRange(0, [self.currentContent length]);
    do {
        NSRange range = [self.currentContent rangeOfString:searchTag options:0 range:searchRange];
        if (range.location != NSNotFound) {
            NSString *s = [self.currentContent substringWithRange:NSMakeRange(range.location, searchTag.length + 1)];
            s = [s stringByReplacingOccurrencesOfString:searchTag withString:@""];
            [self.listSectionIDs addObject:[NSNumber numberWithInt:[s intValue]]];
            searchRange.location = range.location + range.length;
            searchRange.length = [self.currentContent length] - searchRange.location;
        }
        else
            break;
    }
    while (1);

    [self loadContent];
}

- (void)loadContent {
    [self.viewWeb loadHTMLString:self.currentContent baseURL:nil];
}

#pragma mark - UIWebView delegates & methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    float h;
    float heightString = self.viewWeb.scrollView.contentSize.height;
    h = heightString + 12.0f;
    self.viewWeb.frame = CGRectMake(self.viewWeb.frame.origin.x, self.viewWeb.frame.origin.y, self.viewWeb.frame.size.width, h);
    self.contentHeight = self.viewWeb.frame.origin.y + h + 70;
    [self.viewContent setContentSize:CGSizeMake(self.viewWeb.frame.size.width, self.contentHeight)];
    
    // Inject jQuery
    NSString *jsFile = @"jquery-ui-1.10.3.custom.min.js";
    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:[jsFile stringByDeletingPathExtension] ofType:[jsFile pathExtension]];
    NSURL *jsURL = [NSURL fileURLWithPath:jsFilePath];
    NSString *javascriptCode = [NSString stringWithContentsOfFile:jsURL.path encoding:NSUTF8StringEncoding error:nil];
    [self.viewWeb stringByEvaluatingJavaScriptFromString:javascriptCode];
    
    [self initScroll];
}

#pragma mark - Javascript function calls

- (CGRect)javascriptPositionOfElementWithId:(NSString *)elementID {
    NSString *js = @"function f(){ var r = document.getElementById('%@').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";
    NSString *result = [self.viewWeb stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, elementID]];
    CGRect rect = CGRectFromString(result);
    return rect;
}

- (NSString *)javascriptSectionTitleOfElementWithId:(NSString *)elementID {
    NSString *js = @"function f(){ return document.getElementById('%@').innerHTML; } f();";
    NSString *result = [self.viewWeb stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, elementID]];
    return result;
}

- (BOOL)javascriptIsSectionVisible:(int)sectionTag {
    NSString *js = [NSString stringWithFormat:@"isSectionVisible($('#%@%i'), %1.f, %1.f)", self.sectionTitleTag, (sectionTag + 1), self.viewContent.contentOffset.y, self.viewContent.frame.size.height];
    NSString *jsResult = [self.viewWeb stringByEvaluatingJavaScriptFromString:js];
    return [jsResult boolValue];
}

#pragma mark - Scroller initialization

- (void)initScroll {
    self.scrollingItem = [[SNScrollableItem alloc] init];
    [self.scrollingItem setFrame:CGRectMake(1, 1, self.viewScroller.frame.size.width - 2, self.scrollbarWidth - 2)];
    [self.scrollingItem setDelegate:self];
    [self.viewScroller addSubview:self.scrollingItem];

    for (int i=0; i<[self.listSectionIDs count]; i++) {
        UIView *v = [[UIView alloc] init];
        
        int sectionID = [[self.listSectionIDs objectAtIndex:i] intValue];
        
        NSString *sname = [NSString stringWithFormat:@"%@%i", self.sectionTitleTag, sectionID];
        float y = [self javascriptPositionOfElementWithId:sname].origin.y;
        y = (y * self.viewContent.frame.size.height) / self.contentHeight;
        if (i == 0)
            [v setFrame:CGRectMake(5, 4, 10, 10)];
        else
            [v setFrame:CGRectMake(5, y - 10, 10, 10)];
        
        [v setTag:i];
        [v setBackgroundColor:self.colorDefaultSectionDot];
        [v.layer setCornerRadius:5];
        [v.layer setMasksToBounds:YES];
        [self.viewScroller addSubview:v];
        UITapGestureRecognizer *stap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)];
        [stap setNumberOfTapsRequired:1];
        [stap setNumberOfTouchesRequired:1];
        [v addGestureRecognizer:stap];
        [self.listSections addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:i], [NSNumber numberWithFloat:v.frame.origin.y], [NSNumber numberWithFloat:v.frame.size.height], nil]];
    }
    
    [self.viewScroller bringSubviewToFront:self.scrollingItem];
    self.scrollingAccessoryView = [[SNAccessoryView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Scroller delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float y = (self.viewContent.contentOffset.y * self.viewContent.frame.size.height) / self.contentHeight;
    if (y < self.scrollingItem.frame.size.height)
        y = self.scrollingItem.frame.size.height / 2;
    [UIView beginAnimations:@"Dragging Scoller From Content" context:nil];
    [self.scrollingItem setCenter:CGPointMake(self.scrollingItem.center.x, y)];
    [UIView commitAnimations];
    
    BOOL anySectionVisible = NO;
    for (NSArray *arr in self.listSections) {
        int stag = [[arr objectAtIndex:0] intValue];
        float sy = [[arr objectAtIndex:1] floatValue];
        float sh = [[arr objectAtIndex:2] floatValue];
        if (y > sy && y < (sy + sh))
            [self showSection:stag withY:y];

        BOOL sectionVisible = [self javascriptIsSectionVisible:stag];
        if (sectionVisible) {
            [self showSection:stag withY:y];
            anySectionVisible = YES;
        }
    }
    
    if (!anySectionVisible)
        [self hideAccessory];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideAccessory];
}

#pragma mark - Dragging delegates

- (void)draggedUp:(id)sender diff:(float)px {
    float y = (px * self.contentHeight) / self.viewContent.frame.size.height;
    CGRect scrollRect = CGRectMake(0, y, self.viewContent.frame.size.width, self.viewContent.frame.size.height);
    [self.viewContent scrollRectToVisible:scrollRect animated:YES];
    [self hideAccessory];
}

- (void)draggedDown:(id)sender diff:(float)px {
    float y = (px * self.contentHeight) / self.viewContent.frame.size.height;
    CGRect scrollRect = CGRectMake(0, y, self.viewContent.frame.size.width, self.viewContent.frame.size.height);
    [self.viewContent scrollRectToVisible:scrollRect animated:YES];
    [self hideAccessory];
}

#pragma mark - Scrollbar item accessory

- (void)showAccessory {
    [UIView beginAnimations:@"Accessory Show" context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.scrollingAccessoryView setAlpha:1];
    [UIView commitAnimations];
}

- (void)hideAccessory {
    [UIView beginAnimations:@"Accessory Hide" context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.scrollingAccessoryView setAlpha:0];
    [UIView commitAnimations];
    [self.scrollingAccessoryView removeFromSuperview];
}

#pragma mark - Section actions

- (void)sectionTapped:(UIGestureRecognizer *)gesture {
    UIView *v = (UIView *)gesture.view;
    int tid = v.tag;
    float y = v.center.y;
    if (y < self.scrollingItem.center.y)
        [self draggedUp:nil diff:y];
    else
        [self draggedDown:nil diff:y];
    
    [self showSection:tid withY:y];
}

- (void)showSection:(int)tid withY:(float)y {
    NSString *title = [self javascriptSectionTitleOfElementWithId:[NSString stringWithFormat:@"%@%i", self.sectionTitleTag, (tid + 1)]];
    
    if (self.scrollingAccessoryView == nil)
        self.scrollingAccessoryView = [[SNAccessoryView alloc] initWithFrame:CGRectZero];
    [self.scrollingAccessoryView setForegroundColor:self.colorDefaultAccessoryView];
    [self.scrollingAccessoryView.lblText setFont:self.fontSectionTitle];
    [self.scrollingAccessoryView.lblText setText:title];
    [self.scrollingAccessoryView.lblText setTextColor:self.colorDefaultAccessoryViewText];
    
    CGSize maximumLabelSize = CGSizeMake(255, FLT_MAX);
    CGSize expectedTitleSize = [title sizeWithFont:self.scrollingAccessoryView.lblText.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    float ax = 0, ay = 0, aw = 0, ah = 0;
    
    aw = expectedTitleSize.width + self.scrollingAccessoryView.arrowWidth + 10;
    
    ah = expectedTitleSize.height + 11;
    ah += self.scrollingAccessoryView.labelEdgeInsets.top;
    ah += self.scrollingAccessoryView.labelEdgeInsets.bottom;
    
    ax = self.viewScroller.frame.origin.x - aw - 4;

    ay = y - 15;
    if (ay < 0)
        ay = 0;

    [self.scrollingAccessoryView setFrame:CGRectMake(ax, ay, aw, ah)];
    [self addSubview:self.scrollingAccessoryView];
    [self showAccessory];
}

#pragma mark - Color operations

- (UIColor *)colorInjectAlpha:(UIColor *)color withAlpha:(float)alpha {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alphaOriginal = 0.0;
    const CGFloat *colorComponents = CGColorGetComponents(color.CGColor);
    red = colorComponents[0];
    green = colorComponents[1];
    blue = colorComponents[2];
    alphaOriginal = colorComponents[3];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
