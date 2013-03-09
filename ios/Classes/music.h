//
//  music.h
//  iPhoneStreamingPlayer
//
//  Created by Yukis on 13-3-8.
//
//

#import <Foundation/Foundation.h>

@interface music : NSObject

@property (nonatomic,retain) NSString *musicid;
@property (nonatomic) double score;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *url;
+ (music *)getInstance;

@end
