//
//  tagController.h
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-8.
//
//

#import <UIKit/UIKit.h>

@interface tagController : UIViewController
{
    BOOL isTouch[6];
}
- (IBAction)nextTags:(UIButton *)sender;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *tag;
- (IBAction)touched:(UIButton *)sender;
- (void) feedback;
- (void) setTags;
- (IBAction)submit:(UIButton *)sender;

@end
