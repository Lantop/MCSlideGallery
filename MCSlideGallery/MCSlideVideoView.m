//
//  MCSlideVideoView.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideVideoView.h"
#import "MCSlideMedia.h"
#import "MCSlideDefines.h"
#import "MCSlideToolBarView.h"
#import <UIImageView+AFNetworking.h>
#import <EXTScope.h>

@interface MCSlideVideoView ()

@property (nonatomic, strong) MCSlideMedia *media;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) MCSlideToolBarView *controlView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIButton *playpauseBtn;
@property (nonatomic, assign) NSInteger playableDuration;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, assign) BOOL isRemote;

@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

@end


@implementation MCSlideVideoView

- (id)initWithFrame:(CGRect)frame media:(MCSlideMedia *)media remote:(BOOL)remote
{
    self = [super initWithFrame:frame];

    if (self) {
        // register the notification;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                                                 selector:@selector(pageClosed)
                                                     name:kMCSlideViewWillCloseNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itemDidFinished)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];

        self.isRemote = remote;
        self.media = media;
        
        [self videoPlayerInit];
        [self addVideoLayer];
        [self addSubview:self.coverImageView];
        [self addSubview:self.controlView];
        [self addSubview:self.playButton];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Control Init


- (void)videoPlayerInit
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

- (void)addVideoLayer
{
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    [playerLayer setFrame:self.bounds];
    [self.layer addSublayer:playerLayer];
}


- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, self.bounds.size.height)];
        
        if (!self.isRemote) {
            UIImage *image = [UIImage imageWithContentsOfFile:self.media.illustration];
            
            if (image) {
                [self.coverImageView setImage:image];
            } else {
                [self.coverImageView setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_video_default.png"]];
            }
        } else {
            NSURL *imageUrl = [NSURL URLWithString:self.media.illustration];
            [self.coverImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_video_default.png"]];
        }
    }
    
    return _coverImageView;
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
#pragma mark controlview delegate

- (IBAction)playButtonAction:(id)sender
{
    [self.controlView play];
    [self play];
}

- (void)play
{
    self.coverImageView.hidden = YES;
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

- (void)toggleControlView
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
