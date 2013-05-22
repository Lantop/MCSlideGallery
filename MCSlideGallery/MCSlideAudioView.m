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

@property (nonatomic, strong) MCSlideMedia *media;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) MCSlideControlView *controlView;
@property (nonatomic, strong) UIImageView *coverImageView;
//@property (nonatomic, strong) UIButton *playButton;

@end

@implementation MCSlideAudioView

- (id)initWithFrame:(CGRect)frame withMedia:(MCSlideMedia *)media
{
    self = [super initWithFrame:frame];
    self.media = media;
    
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
        
        [self addSubview:self.coverImageView];
        [self audioPlayerInit];
        [self addSubview:self.controlView];
    }
    
    return self;
}

- (void)dealloc
{
    self.audioPlayer.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Control Init


- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        CGRect recg = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _coverImageView = [[UIImageView alloc] initWithFrame:recg];
        UIImage *image = [UIImage imageWithContentsOfFile:self.media.illustration];
        if (image) {
            [_coverImageView setImage:image];
        }
        else {
            [_coverImageView setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/gallery_audio_default.jpg"]];
        }
    }
    
    return _coverImageView;
}

- (void)audioPlayerInit
{
    if (self.media.resource.length > 0) {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:self.media.resource];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        _audioPlayer.delegate = self;
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer prepareToPlay];
    }
}

- (MCSlideControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[MCSlideControlView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - 80.0, self.frame.size.width, 80.0)];
        _controlView.durationData = self.audioPlayer.duration;
        _controlView.slideControlDelegate = self;
    }
    
    return _controlView;
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

- (void)showControlView:(BOOL)animated
{
    NSTimeInterval duration = (animated) ? 0.5 : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.controlView.alpha = 1;
    }];
}

- (void)hideControlView:(BOOL)animated
{
    NSTimeInterval duration = (animated) ? 0.5 : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.controlView.alpha = 0;
    }];
}

- (void)toggleControlsView
{
    if (self.controlView.alpha == 0) {
        [self showControlView:YES];
    } else {
        [self hideControlView:YES];
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
    [self hideControlView:NO];
}

- (void)exitFullScreen
{
    [self showControlView:NO];
}

@end
