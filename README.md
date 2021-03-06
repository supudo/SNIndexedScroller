HTML content display, with custom scroller, showing specific sections throughout the document as markers in the scroll. On position it displays the currently scrolled section.
Section titles are parsed automatically from the document.

# Usage

###Add files

Add all files from the "SNIndexedScroller" into your project.

###Import SNScrollView.h

```objectivec
#import "SNScrollView.h"
 ```

Import the scroll header file into the file you're planing to use it in.
 
###Initialize and add to current view

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

content.txt is the file containing the HTML to be displayed. "section" is the ID tag marking each section in the document.
So for example a section could be :

```html
<strong id="section1">Lorem ipsum</strong>
```

or

```html
<span id="section2">Lorem ipsum</span>
```


Use, change, rewrite, drop me a line ... whatever fits your needs :)

... THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND ...