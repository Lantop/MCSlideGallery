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
#import "MCSlideMoviePlayerViewController.h"
#import <UIImageView+AFNetworking.h>


@interface MCSlideVideoView ()

@property (nonatomic, strong) MCSlideMedia *media;
@property (nonatomic, strong) MCSlideMoviePlayerViewController *moviePlayerViewController;
@property (nonatomic, strong) MCSlideToolBarView *controlView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIButton *playpauseBtn;
@property (nonatomic, assign) NSInteger playableDuration;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, assign) BOOL isRemote;

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
                                                 selector:@selector(refreshDuration)
                                                     name:MPMovieDurationAvailableNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pageChanged)
                                                     name:kMCSlidePageChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pageClosed)
                                                     name:kMCSlideViewWillCloseNotification
                                                   object:nil];

        self.isRemote = remote;
        self.media = media;
        [self moviePlayerInit];
        [self playControlInit];
        [self addSubview:self.playButton];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)moviePlayerInit
{
    self.moviePlayerViewController = [[MCSlideMoviePlayerViewController alloc] init];
    self.moviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;

    [self addSubview:self.moviePlayerViewController.view];

    if (self.isRemote) {
        [self setRemoteResource];
    } else {
        [self setLoaclResource];
    }

    [self.moviePlayerViewController.moviePlayer prepareToPlay];
}

#pragma mark -
#pragma mark Set Resource

- (void)setLoaclResource
{
    self.moviePlayerViewController.moviePlayer.contentURL = [NSURL fileURLWithPath:self.media.resource];

    // default video image
    if (!self.coverImageView) {
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, self.bounds.size.height)];
        UIImage *image = [UIImage imageWithContentsOfFile:self.media.illustration];

        if (image) {
            [self.coverImageView setImage:image];
        } else {
            [self.coverImageView setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_video_default.png"]];
        }

        [self addSubview:self.coverImageView];
    }
}

- (void)setRemoteResource
{
    self.moviePlayerViewController.moviePlayer.contentURL = [NSURL URLWithString:self.media.resource];

    // default video image
    if (!self.coverImageView) {
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, self.bounds.size.height)];
        NSURL *imageUrl = [NSURL URLWithString:self.media.illustration];
        [self.coverImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_video_default.png"]];

        [self addSubview:self.coverImageView];
    }
}

- (void)playControlInit
{
    self.controlView = [[MCSlideToolBarView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - 40.0, self.frame.size.width, 40.0)];

    if ([self.moviePlayerViewController.moviePlayer isPreparedToPlay]) {
        [self.controlView setDurationData:self.moviePlayerViewController.moviePlayer.duration];
    }

    self.controlView.slideControlDelegate = self;
    [self addSubview:self.controlView];
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

- (void)refreshDuration
{
    [self.controlView setDurationData:self.moviePlayerViewController.moviePlayer.duration];
}

- (void)resetPlayer
{
    [self.moviePlayerViewController.moviePlayer setCurrentPlaybackTime:0];
    self.controlView.currentPlayPosition = 0;
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
    //    self.playerControlsView.duration = self.moviePlayerViewController.moviePlayer.duration;
    //    self.playerControlsView.currentPlayPosition = self.moviePlayerViewController.moviePlayer.currentPlaybackTime;
    [self.moviePlayerViewController.moviePlayer play];
    self.playButton.hidden = YES;
}

- (void)pause
{
    [self.moviePlayerViewController.moviePlayer pause];
    self.playButton.hidden = NO;
}


- (void)backward
{
    CGFloat currentTime = self.moviePlayerViewController.moviePlayer.currentPlaybackTime;

    if ((currentTime - kMCSlideVideoPlayOffset) < 0) {
        currentTime = 0;
    } else {
        currentTime -= kMCSlideVideoPlayOffset;
    }

    [self.moviePlayerViewController.moviePlayer setCurrentPlaybackTime:currentTime];
}

- (void)forward
{
    CGFloat currentTime = self.moviePlayerViewController.moviePlayer.currentPlaybackTime;

    if ((currentTime + kMCSlideVideoPlayOffset) > self.moviePlayerViewController.moviePlayer.duration) {
        currentTime = self.moviePlayerViewController.moviePlayer.duration - 1.0;
    } else {
        currentTime += kMCSlideVideoPlayOffset;
    }

    [self.moviePlayerViewController.moviePlayer setCurrentPlaybackTime:currentTime];
}

- (void)sliderChangedWithValue:(CGFloat)value
{
    [self.moviePlayerViewController.moviePlayer setCurrentPlaybackTime:value];
}

- (void)playFinished
{
    self.coverImageView.hidden = NO;
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

@end
