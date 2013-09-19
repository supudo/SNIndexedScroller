Custom indexed scroller for large texts.

## Usage

1. Import SNScrollView.h

```objectivec
#import "SNScrollView.h"
 ```
 
2. Initialize and add to current view

```objectivec
SNScrollView *sv = [[SNScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
[sv setupSectionID:@"section"];
[sv setColorScroller:[UIColor greenColor] withAlpha:.8f];
[sv setColorSectionDot:[UIColor redColor] withAlpha:1];
[sv setColorAccessoryView:[UIColor blueColor] withAlpha:1];
[sv setFontAccessoryView:[UIFont boldSystemFontOfSize:16] withColor:[UIColor redColor]];
[sv showContentWithFile:@"content.txt"];
[self.view addSubview:sv];
```