//
//  SceneController.h
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-4.
//
//

#import <UIKit/UIKit.h>

@interface SceneController : UIViewController
- (IBAction)runPressed:(UIButton *)sender;
- (IBAction)restPressed:(UIButton *)sender;
- (IBAction)outsidePressed:(UIButton *)sender;
- (IBAction)workPressed:(UIButton *)sender;
- (void)update;

@property (retain, nonatomic) IBOutlet UIButton *restButton;
@property (retain, nonatomic) IBOutlet UIButton *runButton;
@property (retain, nonatomic) IBOutlet UIButton *outsideButton;
@property (retain, nonatomic) IBOutlet UIButton *workButton;

@end
