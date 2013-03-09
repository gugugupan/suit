//
//  music.m
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-8.
//
//

#import "music.h"

@implementation music
@synthesize musicid;
@synthesize score;

+(music *)getInstance
{
    static music *instance = nil;
    @synchronized(self)
    {
        if (!instance) instance = [[music alloc] init];
        return instance;
    }
}

@end
