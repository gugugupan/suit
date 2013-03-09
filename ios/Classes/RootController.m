//
//  RootController.m
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-4.
//
//

#import "RootController.h"
#import "iPhoneStreamingPlayerViewController.h"
#import "SceneController.h"
#import "user.h"
#import "tagController.h"
@interface RootController ()

@end

@implementation RootController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIGraphicsBeginImageContext(_backgroundView.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:_backgroundView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _backgroundView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    _shadowView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _shadowView.backgroundColor = [UIColor blackColor];
    _shadowView.alpha = 0.5;
    [self.view addSubview:_backgroundView];
    [self.view sendSubviewToBack:_backgroundView];
    [self.view insertSubview:_shadowView aboveSubview:_backgroundView];
    
    NSString *filepath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        NSArray * array = [[NSArray alloc] initWithContentsOfFile:filepath];
        [user getInstance].userid = [array objectAtIndex:0];
        [user getInstance].env = 4; //default environment : rest
    }
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save:) name:UIApplicationWillResignActiveNotification object:app];
    if ([user getInstance].userid == nil)
    {
        [self createUser];
        [self setSceneButtonImage];
        self.tag = [[tagController alloc] initWithNibName:@"tagController" bundle:nil];
        [self.view insertSubview:self.tag.view aboveSubview:self.self.shadowView];
        self.sceneButton.hidden = YES;
    }
    else
    {
        self.sceneButton.hidden = NO;
        if (self.playerController == nil) self.playerController = [[iPhoneStreamingPlayerViewController alloc] initWithNibName:@"iPhoneStreamingPlayerViewController" bundle:nil];
        [self.view insertSubview:self.playerController.view belowSubview:self.sceneButton];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(player:) name:@"submit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"update" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runEnv:) name:@"shake" object:nil];
}
- (void) runEnv:(NSNotification *)notification
{
    [user getInstance].env = 2;
    [self setSceneButtonImage];
}
- (void) createUser
{
    NSString *get = @"http://10.141.247.17:3001/users/create.json";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:get]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSError *error;
    if (response)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        [user getInstance].userid = [dic objectForKey:@"id"];
        NSLog(@"%@",[user getInstance].userid);
    }
}
- (void) player:(NSNotification*)notification
{
    self.sceneButton.hidden = NO;
    if (self.playerController == nil) self.playerController = [[iPhoneStreamingPlayerViewController alloc] initWithNibName:@"iPhoneStreamingPlayerViewController" bundle:nil];
    [self.view insertSubview:self.playerController.view belowSubview:self.sceneButton];
}

- (void)save:(NSNotification *)notification
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[user getInstance].userid];
    [array writeToFile:[self dataFilePath] atomically:YES];
}

- (void) update:(NSNotification *)notification
{
    [self setSceneButtonImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender {
    if (self.sceneController == nil) self.sceneController = [[SceneController alloc] initWithNibName:@"SceneController" bundle:nil];
    if (self.sceneController.view.superview == nil)
    {
        [self.sceneButton setImage:[UIImage imageNamed:@"scene_normal.png"] forState:0];
        [self.view insertSubview:self.sceneController.view aboveSubview:self.playerController.view];
    }
    else
    {
        [self.sceneController.view removeFromSuperview];
        [self setSceneButtonImage];
    }
}
- (void) setSceneButtonImage
{
    if ([user getInstance].env == 1) [self.sceneButton setImage:[UIImage imageNamed:@"outside.png"] forState:0];
    if ([user getInstance].env == 2) [self.sceneButton setImage:[UIImage imageNamed:@"run.png"] forState:0];
    if ([user getInstance].env == 3) [self.sceneButton setImage:[UIImage imageNamed:@"work.png"] forState:0];
    if ([user getInstance].env == 4) [self.sceneButton setImage:[UIImage imageNamed:@"rest.png"] forState:0];
    
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    return [directory stringByAppendingPathComponent:@"data.txt"];
}
- (void)dealloc {
    [_sceneButton release];
    [super dealloc];
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake )
	{
		// User was shaking the device. Post a notification named "shake".
		[[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
	}
}
- (BOOL)canBecomeFirstResponder { return YES; }


@end
