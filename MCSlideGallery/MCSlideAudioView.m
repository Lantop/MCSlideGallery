//
//  MCSlideAudioView.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideAudioView.h"
#import "MCSlideDefines.h"
#import "MCSlideMedia.h"
#import "MCSlideControlView.h"

@interface MCSlideAudioView ()

@property (nonatomic, strong) UIButton *playButton;

@end

@implementation MCSlideAudioView

- (id)initWithFrame:(CGRect)frame withMedia:(MCSlideMedia *)media
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // register the notification;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterFullScreen)
                                                     name:kMCSlideViewWillEnterFullScreenNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(exitFullScreen)
                                                     name:kMCSlideViewWillExitFullScreenNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pageChanged)
                                                     name:kMCSlidePageChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pageChanged)
                                                     name:kMCSlideViewWillCloseNotification
                                                   object:nil];
        
        self.backgroundColor = [UIColor grayColor];
        CGRect recg = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.noteView = [[UIImageView alloc] initWithFrame:recg];
        UIImage *image = [UIImage imageWithContentsOfFile:media.illustration];
        if (image) {
            [self.noteView setImage:image];
        }
        else {
            [self.noteView setImage:[UIImage imageNamed:@"gallery_audio_default.jpg"]];
        }
        [self addSubview:self.noteView];
        
        [self audioPlayerInit:media.resource];
        [self playControlInit];
    }
    
    return self;
}

- (void)dealloc
{
    self.audioPlayer.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)audioPlayerInit:(NSString *)url
{
    if ([url length] > 0) {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:url
                          ];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer setNumberOfLoops:0];
    }
}

- (void)playControlInit
{
    self.controlView = [[MCSlideControlView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - 80.0, self.frame.size.width, 80.0)];
    [self.controlView setDurationData:self.audioPlayer.duration];
    self.controlView.slideControlDelegate = self;
    [self addSubview:self.controlView];
}

#pragma mark -
#pragma mark Tap event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Interface implement

- (void)play
{
    //    self.playerControlsView.currentPlayPosition = self.audioPlayer.currentTime;
    //    self.playerControlsView.duration = self.audioPlayer.duration;
    
    [self.audioPlayer play];
}

- (void)pause
{
    [self.audioPlayer pause];
}

- (void)togglePlayback:(id)sender
{
}

- (void)backward
{
    CGFloat currentTime = self.audioPlayer.currentTime;
    
    if ((currentTime - kMCSlideVideoPlayOffset) < 0) {
        currentTime = 0;
    } else {
        currentTime -= kMCSlideVideoPlayOffset;
    }
    
    [self.audioPlayer setCurrentTime:currentTime];
}

- (void)forward
{
    CGFloat currentTime = self.audioPlayer.currentTime;
    
    if ((currentTime + kMCSlideVideoPlayOffset) > self.audioPlayer.duration) {
        currentTime = self.audioPlayer.duration - 1.0;
    } else {
        currentTime += kMCSlideVideoPlayOffset;
    }
    
    [self.audioPlayer setCurrentTime:currentTime];
}

- (void)sliderChangedWithValue:(CGFloat)value
{
    //    CGFloat time = self.audioPlayer.duration * value;
    
    [self.audioPlayer setCurrentTime:value];
}

- (void)playFinished
{
    //nothing
}

#pragma mark -
#pragma mark Fullscreen event

- (void)showControlsView:(BOOL)animated
{
    NSTimeInterval duration = (animated) ? 0.5 : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.controlView.alpha = 1;
    }];
}

- (void)hideControlsView:(BOOL)animated
{
    NSTimeInterval duration = (animated) ? 0.5 : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.controlView.alpha = 0;
    }];
}

- (void)toggleControlsView
{
    if (self.controlView.alpha == 0) {
        [self showControlsView:YES];
    } else {
        [self hideControlsView:YES];
    }
}


#pragma mark -
#pragma mark AVAudioPlayer delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
}


#pragma mark -
#pragma mark page changed delegate

- (void)pageChanged
{
    if (self.controlView.isPlaying) {
        [self pause];
        [self.controlView pause];
    }
}

- (void)pageClosed
{
    if (self.controlView.isPlaying) {
        [self pause];
        [self.controlView pause];
    }
}


#pragma mark -
#pragma mark Enter full screen notification

- (void)enterFullScreen
{
    [self hideControlsView:NO];
}

- (void)exitFullScreen
{
    [self showControlsView:NO];
}

@end
