//
//  testButton.h
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-6.
//
//

#import <UIKit/UIKit.h>

@interface testButton : UIButton{
    UIBezierPath *path;
    UIColor *color;
}
- (id)initWithPerc:(double)perc Color:(UIColor*)c;
@end
