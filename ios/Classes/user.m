//
//  user.m
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-7.
//
//

#import "user.h"

@implementation user

@synthesize userid;
@synthesize env;

+ (user*)getInstance
{
    static user *instance = nil;
    @synchronized(self)
    {
        if (!instance) instance = [[user alloc] init];
        return instance;
    }
}
@end
