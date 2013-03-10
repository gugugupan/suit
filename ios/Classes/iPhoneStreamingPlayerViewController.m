//
//  iPhoneStreamingPlayerViewController.m
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

#import "iPhoneStreamingPlayerViewController.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "SceneController.h"
#import "testButton.h"
#import "user.h"
#import "music.h"

@implementation iPhoneStreamingPlayerViewController


//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
			removeObserver:self
			name:ASStatusChangedNotification
			object:streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer:(NSString *)musicurl
{
	if (streamer)
	{
		return;
	}

	[self destroyStreamer];
	NSString *escapedValue =
		[(NSString *)CFURLCreateStringByAddingPercentEscapes(
			nil,
			(CFStringRef)musicurl,
			NULL,
			NULL,
			kCFStringEncodingUTF8)
		autorelease];
	NSURL *url = [NSURL URLWithString:escapedValue];
    
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	progressUpdateTimer =
		[NSTimer
			scheduledTimerWithTimeInterval:0.1
			target:self
			selector:@selector(updateProgress:)
			userInfo:nil
			repeats:YES];
    
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(playbackStateChanged:)
		name:ASStatusChangedNotification
		object:streamer];
}

//
// viewDidLoad
//
// Creates the volume slider, sets the default path for the local file and
// creates the streamer immediately if we already have a file at the local
// location.
//
- (void)viewDidLoad
{
	[super viewDidLoad];
    
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
	[volumeSlider addSubview:volumeView];
	[volumeView sizeToFit];
	
    [button setImage:[UIImage imageNamed:@"go.png"] forState:0];
    [_likeButton setImage:[UIImage imageNamed:@"like.png"] forState:0];
    [_nextButton setImage:[UIImage imageNamed:@"next_normal.png"] forState:0];
    
    positionLabel.hidden = YES;
    //back = [[testButton alloc] initWithPerc:1 Color:[UIColor blueColor]];
    //[self.view insertSubview:back belowSubview:button];
    //[back release];
    
    
}

//
// spinButton
//
// Shows the spin button when the audio is loading. This is largely irrelevant
// now that the audio is loaded from a local file.
//
- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [button frame];
	button.layer.anchorPoint = CGPointMake(0.5, 0.5);
	button.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];

	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[button.layer addAnimation:animation forKey:@"rotationAnimation"];

	[CATransaction commit];
}

//
// animationDidStop:finished:
//
// Restarts the spin animation on the button when it ends. Again, this is
// largely irrelevant now that the audio is loaded from a local file.
//
// Parameters:
//    theAnimation - the animation that rotated the button.
//    finished - is the animation finised?
//
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self spinButton];
	}
}

//
// buttonPressed:
//
// Handles the play/stop button. Creates, observes and starts the
// audio streamer when it is a play button. Stops the audio streamer when
// it isn't.
//
// Parameters:
//    sender - normally, the play/stop button.
//
- (BOOL) getMusic
{
    
    NSString *get = [NSString stringWithFormat:@"http://10.141.247.17:3001/users/%@/fetch_music.json?env=%d",
                     [user getInstance].userid,[user getInstance].env];
    //NSLog(@"%@",get);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:get]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    //NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    NSError *error;
    if (response)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        [music getInstance].musicid = [dic objectForKey:@"id"];
        [music getInstance].name = [dic objectForKey:@"name"];
        [music getInstance].artist = [dic objectForKey:@"artist"];
        [music getInstance].url = [dic objectForKey:@"url"];
        [music getInstance].score = 0;
        
        return YES;
    }
    else
    {
        NSLog(@"connection failed");
        return NO;
    }
    
}

- (IBAction)buttonPressed:(id)sender
{
	if ([button.currentImage isEqual:[UIImage imageNamed:@"go.png"]])
	{
        if (!streamer)
        {
            [button setImage:[UIImage imageNamed:@"pause.png"] forState:0];
            if ([self getMusic] == YES)
            {
                if ([music getInstance])
                {
                    [_name setText:[music getInstance].name];
                    [_artist setText:[music getInstance].artist];
                    [self createStreamer:[music getInstance].url];
                    [streamer start];
                }
            }
        }
        else [streamer  start];
	}
	else
	{
        [button setImage:[UIImage imageNamed:@"go.png"] forState:0];
		[streamer pause];
	}
}
- (IBAction)likeButtonPressed:(id)sender
{
    if ([_likeButton.currentImage isEqual:[UIImage imageNamed:@"like.png"]])
    {
        [_likeButton setImage:[UIImage imageNamed:@"liked.png"] forState:0];
        [music getInstance].score = 1;
    }
    else
    {
        [_likeButton setImage:[UIImage imageNamed:@"like.png"] forState:0];
        [music getInstance].score = 0;
    }
}
- (IBAction)nextButtonPressed:(id)sender
{
    [_nextButton setImage:[UIImage imageNamed:@"next_normal.png"] forState:0];
    [_likeButton setImage:[UIImage imageNamed:@"like.png"] forState:0];
    [self feedback:streamer.progress/streamer.duration];
    [self destroyStreamer];
    [button setImage:[UIImage imageNamed:@"pause.png"] forState:0];
    if ([self getMusic] == YES)
    {
        if ([music getInstance])
        {
            [_name setText:[music getInstance].name];
            [_artist setText:[music getInstance].artist];
            [self createStreamer:[music getInstance].url];
            [streamer start];
        }
    }
}
- (void) feedback:(double)perc
{
    if ([music getInstance].score != 1)
        [music getInstance].score = 0.9 * perc;
    NSString *get = [NSString stringWithFormat:
                     @"http://10.141.247.17:3001/users/%@/feedback.json?music_id=%@&score=%.1f",
                     [user getInstance].userid,
                     [music getInstance].musicid,
                     [music getInstance].score];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:get]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"POST"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
   [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
}

- (IBAction)nextButtonDown:(id)sender
{
    [_nextButton setImage:[UIImage imageNamed:@"next_active.png"] forState:0];
}

//
// sliderMoved:
//
// Invoked when the user moves the slider
//
// Parameters:
//    aSlider - the slider (assumed to be the progress slider)
//
- (IBAction)sliderMoved:(UISlider *)aSlider
{
	if (streamer.duration)
	{
		double newSeekTime = (aSlider.value / 100.0) * streamer.duration;
		[streamer seekToTime:newSeekTime];
	}
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		//[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
	}
	else if ([streamer isPlaying])
	{
		[button setImage:[UIImage imageNamed:@"pause.png"] forState:0];
	}/*
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
        [button setImage:[UIImage imageNamed:@"go.png"] forState:0];
	}*/
}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{
	if (streamer.bitRate != 0.0)
	{
		double progress = streamer.progress;
		double duration = streamer.duration;
		if (duration > 0)
		{
			/*[positionLabel setText:
				[NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",
					progress,
					duration]];*/
			[progressSlider setEnabled:YES];
			[progressSlider setValue:100 * progress / duration];
		}
		else
		{
			[progressSlider setEnabled:NO];
		}
	}
	else
	{
		//positionLabel.text = @"Time Played:";
	}
}


//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
	[self destroyStreamer];
	if (progressUpdateTimer)
	{
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
    [_likeButton release];
    [_nextButton release];
    [_name release];
    [_artist release];
	[super dealloc];
}

@end
