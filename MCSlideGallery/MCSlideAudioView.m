//
//  MCSlideRemoteAudioView.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 10/11/14.
//  Copyright (c) 2014 Lanvige Jiang. All rights reserved.
//

#import "MCSlideAudioView.h"
#import "MCSlideDefines.h"
#import "MCSlideMedia.h"
#import "MCSlideToolBarView.h"
#import <UIImageView+AFNetworking.h>
#import <EXTScope.h>

@interface MCSlideAudioView()

@property (nonatomic, strong) MCSlideMedia *media;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) MCSlideToolBarView *controlView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, assign) BOOL isRemote;

@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

@end

@implementation MCSlideAudioView

- (id)initWithFrame:(CGRect)frame media:(MCSlideMedia *)media remote:(BOOL)remote
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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itemDidFinished)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];

        self.backgroundColor = [UIColor grayColor];
        self.isRemote = remote;
        self.media = media;

        [self addSubview:self.coverImageView];
        [self audioPlayerInit];
        [self addSubview:self.controlView];
        [self addSubview:self.playButton];
    }

    return self;
}

- (void)dealloc
{
    //self.audioPlayer.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Control Init


- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        CGRect recg = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _coverImageView = [[UIImageView alloc] initWithFrame:recg];

        NSURL *imageUrl = [NSURL URLWithString:self.media.illustration];
        UIImage *defaultImage = [UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_audio_default.png"];

        // Set resource
        [_coverImageView setImageWithURL:imageUrl placeholderImage:defaultImage];
    }

    return _coverImageView;
}

- (void)audioPlayerInit
{
    if (self.media.resource.length > 0) {
        NSURL *audioUrl = nil;
        if (self.isRemote) {
            audioUrl = [NSURL URLWithString:self.media.resource];
        } else {
            audioUrl = [[NSURL alloc] initFileURLWithPath:self.media.resource];
        }
        
        AVAsset *asset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
        AVPlayerItem *palyerItem = [AVPlayerItem playerItemWithAsset:asset];

        self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:palyerItem];
        
        CMTime time = asset.duration;
        self.duration = (CGFloat)CMTimeGetSeconds(time);
        self.minValue = 0;
        self.maxValue = self.duration;
        [self.controlView setProgressSliderWithMinValue:self.minValue maxValue:self.maxValue];
        
        // Add periodic
        @weakify(self)
        CMTime t = CMTimeMake(1, 2);
        [self.avPlayer addPeriodicTimeObserverForInterval:t queue:nil usingBlock:^(CMTime time) {
            @strongify(self)
            [self syncProgressSlider];
        }];
    }
}

- (MCSlideToolBarView *)controlView
{
    if (!_controlView) {
        _controlView = [[MCSlideToolBarView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - 40.0, self.frame.size.width, 40.0)];
        _controlView.slideControlDelegate = self;
    }

    return _controlView;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(self.frame.size.width / 2 - 40.f, self.frame.size.height / 2 - 40.f, 79.f, 79.f);
        [_playButton setBackgroundImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_player_play.png"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _playButton;
}


#pragma mark -
#pragma mark MCControlDelegation Implement

- (IBAction)playButtonAction:(id)sender
{
    [self.controlView play];
    [self play];
}

- (void)play
{
    [self.avPlayer play];
    self.playButton.hidden = YES;
}

- (void)pause
{
    [self.avPlayer pause];
    self.playButton.hidden = NO;
}

- (void)backward
{
    CGFloat time = [self currentTime];

    if ((time - kMCSlideVideoPlayOffset) < 0) {
        time = 0;
    } else {
        time -= kMCSlideVideoPlayOffset;
    }

    [self seekToTimeWithValue:time];
}

- (void)forward
{
    CGFloat time = [self currentTime];

    if ((time + kMCSlideVideoPlayOffset) > self.duration) {
        time = self.duration - 1.0;
    } else {
        time += kMCSlideVideoPlayOffset;
    }

    [self seekToTimeWithValue:time];
}

- (void)sliderChangedWithValue:(CGFloat)value
{
    [self seekToTimeWithValue:value];
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
#pragma mark Tap event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
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


#pragma mark -
#pragma mark AVPlayer Notification

- (void)itemDidFinished
{
    [self playFinished];
}


#pragma mark -
#pragma mark Public Methods

- (CGFloat)currentTime
{
    return CMTimeGetSeconds(self.avPlayer.currentTime);
}

- (void)seekToTimeWithValue:(CGFloat)value
{
    [self.avPlayer seekToTime:(CMTimeMakeWithSeconds(value, (NSInteger)NSEC_PER_SEC))];
}

- (void)playFinished
{
    [self.avPlayer seekToTime:(CMTimeMake(0, NSEC_PER_SEC))];
    [self pause];
    [self.controlView pause];
}

- (void)syncProgressSlider
{
    // 计算进度
    // CGFloat value = (self.maxValue - self.minValue) * (time / self.duration) + self.minValue;
    // 更新进度条
    [self.controlView updatePrgressSlider:[self currentTime]];
}


@end
