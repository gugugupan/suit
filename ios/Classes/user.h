//
//  user.h
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-7.
//
//

#import <Foundation/Foundation.h>

@interface user : NSObject

@property (nonatomic,retain) NSString *userid;
@property (nonatomic) int env;

+ (user *)getInstance;
@end
