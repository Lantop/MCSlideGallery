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
#import "MCSlideControlView.h"
#import "MCSlideMoviePlayerViewController.h"

@interface MCSlideVideoView ()

@property (nonatomic, strong) MCSlideMedia *media;
@property (nonatomic, strong) MCSlideMoviePlayerViewController *moviePlayerViewController;
@property (nonatomic, strong) MCSlideControlView *controlView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIButton *playpauseBtn;
@property (nonatomic, assign) NSInteger playableDuration;
@property (nonatomic, strong) UIImageView *imageViewDefault;

@end


@implementation MCSlideVideoView

- (id)initWithFrame:(CGRect)frame withMedia:(MCSlideMedia *)media
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

        self.media = media;
        [self moviePlayerInit];
        [self playControlInit];
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
    self.moviePlayerViewController.moviePlayer.contentURL = [NSURL fileURLWithPath:self.media.resource];
    [self.moviePlayerViewController.moviePlayer prepareToPlay];
    [self addSubview:self.moviePlayerViewController.view];

    // default video image
    if (!self.imageViewDefault) {
        self.imageViewDefault = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, self.bounds.size.height)];
        UIImage *image = [UIImage imageWithContentsOfFile:self.media.illustration];

        if (image) {
            [self.imageViewDefault setImage:image];
        } else {
            [self.imageViewDefault setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/gallery_movie_default.jpg"]];
        }

        [self addSubview:self.imageViewDefault];
    }
}

- (void)playControlInit
{
    self.controlView = [[MCSlideControlView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - 80.0, self.frame.size.width, 80.0)];

    if ([self.moviePlayerViewController.moviePlayer isPreparedToPlay]) {
        [self.controlView setDurationData:self.moviePlayerViewController.moviePlayer.duration];
    }

    self.controlView.slideControlDelegate = self;
    [self addSubview:self.controlView];
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

- (void)play
{
    self.imageViewDefault.hidden = YES;
    //    self.playerControlsView.duration = self.moviePlayerViewController.moviePlayer.duration;
    //    self.playerControlsView.currentPlayPosition = self.moviePlayerViewController.moviePlayer.currentPlaybackTime;
    [self.moviePlayerViewController.moviePlayer play];
}

- (void)pause
{
    [self.moviePlayerViewController.moviePlayer pause];
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
    self.imageViewDefault.hidden = NO;
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
