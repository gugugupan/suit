//
//  tagController.m
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-8.
//
//

#import "tagController.h"
#import "user.h"
@interface tagController ()

@end

@implementation tagController

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
    [self setTags];
    // Do any additional setup after loading the view from its nib.
}
- (void) feedback
{
    NSString *get = [NSString stringWithFormat:
                         @"http://10.141.247.17:3001/users/%@/set_tag.json?tag=",
                         [user getInstance].userid];
    for (UIButton *t in _tag)
    {
        if (isTouch[[_tag indexOfObject:t]])
            get = [get stringByAppendingFormat:@"%@,",t.titleLabel.text];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:get]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];

}
- (void) setTags
{
    NSString *get = @"http://10.141.247.17:3001/tags/fetch.json";
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
        for (UIButton *t in _tag)
        {
            [t setTitle:[dic objectForKey:[[NSString alloc] initWithFormat:@"tag%d",[_tag indexOfObject:t]]]
               forState:0];
            NSLog(@"%@",[dic objectForKey:[[NSString alloc] initWithFormat:@"tag%d",[_tag indexOfObject:t]]]);
            [t setTitleColor:[UIColor whiteColor] forState:0];
            isTouch[[_tag indexOfObject:t]] = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(UIButton *)sender {
    [self feedback];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"submit" object:nil];
    [self.view removeFromSuperview];
}
- (void)dealloc {

    [_tag release];
    [super dealloc];
}
- (IBAction)touched:(UIButton *)sender {
    if (!isTouch[[_tag indexOfObject:sender]])
    {
        [sender setTitleColor:[UIColor colorWithRed:255.0 /255 green:50.0/255 blue:100.0 /255 alpha:1.0] forState:0];
        isTouch[[_tag indexOfObject:sender]] = YES;
    }
    else
    {
        [sender setTitleColor:[UIColor whiteColor] forState:0];
        isTouch[[_tag indexOfObject:sender]] = NO;
    }
}
- (IBAction)nextTags:(UIButton *)sender {
    [self feedback];
    [self setTags];
}
@end
