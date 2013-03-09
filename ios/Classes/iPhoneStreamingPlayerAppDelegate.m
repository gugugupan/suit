//
//  iPhoneStreamingPlayerAppDelegate.m
//  iPhoneStreamingPlayer
//
//  Created by Matt Gallagher on 28/10/08.
//  Copyright Matt Gallagher 2008. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "iPhoneStreamingPlayerAppDelegate.h"
#import "RootController.h"

@implementation iPhoneStreamingPlayerAppDelegate

@synthesize window;
@synthesize rootController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    self.rootController = [[RootController alloc] initWithNibName:@"RootController" bundle:nil];
    // Override point for customization after app launch    
    [window setRootViewController:rootController];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [rootController release];
    [window release];
    [super dealloc];
}
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    NSLog(@"fucking");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"motion" object:nil userInfo:nil];
    
}


@end
