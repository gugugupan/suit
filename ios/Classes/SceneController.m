//
//  SceneController.m
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-4.
//
//

#import "SceneController.h"
#import "user.h"
@interface SceneController ()

@end

@implementation SceneController

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
    /*[_workButton setImage:[UIImage imageNamed:@"work.png"] forState:0];
    [_outsideButton setImage:[UIImage imageNamed:@"outside.png"] forState:0];
    [_runButton setImage:[UIImage imageNamed:@"run.png"] forState:0];
    [_restButton setImage:[UIImage imageNamed:@"rest.png"] forState:0];*/
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_workButton release];
    [_outsideButton release];
    [_runButton release];
    [_restButton release];
    [super dealloc];
}

-(void) update
{
    [self.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
}
- (IBAction)runPressed:(UIButton *)sender {
    [user getInstance].env = 2;
    [self update];
}

- (IBAction)restPressed:(UIButton *)sender {
    [user getInstance].env = 4;
    [self update];
}

- (IBAction)outsidePressed:(UIButton *)sender {
    [user getInstance].env = 1;
    [self update];
}

- (IBAction)workPressed:(UIButton *)sender {
    [user getInstance].env = 3;
    [self update];
}
@end
