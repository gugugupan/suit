//
//  RootController.h
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-4.
//
//

#import <UIKit/UIKit.h>
@class iPhoneStreamingPlayerViewController;
@class SceneController;
@class tagController;

@interface RootController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *sceneButton;
@property(strong,nonatomic) iPhoneStreamingPlayerViewController *playerController;
@property(strong,nonatomic) tagController *tag;
@property(strong,nonatomic) SceneController *sceneController;
@property(strong,nonatomic) UIView *shadowView;
@property(strong,nonatomic) UIView *backgroundView;

- (IBAction)buttonPressed:(UIButton *)sender;
- (void)setSceneButtonImage;
- (void)createUser;
@end
