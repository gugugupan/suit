//
//  testButton.m
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-6.
//
//

#import "testButton.h"

@implementation testButton

- (id)initWithPerc:(double)perc Color:(UIColor*)c
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(110, 390)
                                                             radius:70
                                                         startAngle:3.141592653589
                                                           endAngle:3.141592653589 * (1 + perc)
                                                          clockwise:YES];
       color = c;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    
    // Set the render colors
    [color setStroke];
    [[UIColor clearColor] setFill];
    
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    CGContextTranslateCTM(aRef, 50, 50);
    
    // Adjust the drawing options as needed.
    path.lineWidth = 5;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [path fill];
    [path stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
}

@end
