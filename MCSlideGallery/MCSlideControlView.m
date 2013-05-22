//
//  MCSlideControlView.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideControlView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MCSlideDefines.h"

static const NSInteger labelHeight = 20.0; // current and count time label height
static const NSInteger labelWight = 60.0; // current and count time label wight
static const NSInteger btnHeight = 60.0; // forward playpause backward button height
static const NSInteger btnWight = 80.0; // forward playpause backward button wight


@interface MCSlideControlView ()

@property (nonatomic, strong) UIImageView *imgViewBG;  // backgound imagview

@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *backwardButton;
@property (nonatomic, strong) NSTimer *playbackTickTimer;  // time to refresh slider and current time label

@end


@implementation MCSlideControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self viewInit];

        // add observer to notificationcenter for playing finished
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(trackFinished)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
    }

    return self;
}

- (void)viewInit
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.8;

    // background view
    self.imgViewBG = [[UIImageView alloc] initWithFrame:self.frame];
    self.imgViewBG.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imgViewBG];

    // current time
    self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, labelWight, labelHeight)];
    self.currentTimeLabel.font = [UIFont systemFontOfSize:14.0];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.currentTimeLabel];
    self.currentTimeLabel.text = @"00:00"; // set default

    // play slider
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(labelWight + 5.0, 0.0, self.frame.size.width - (labelWight + 5.0) * 2, 7.0)];
    [self.progressSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.progressSlider.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressSlider];

    // count time
    self.mediaLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - labelWight, 0.0, labelWight, labelHeight)];
    self.mediaLengthLabel.font = [UIFont systemFontOfSize:14.0];
    self.mediaLengthLabel.textColor = [UIColor whiteColor];
    self.mediaLengthLabel.backgroundColor = [UIColor clearColor];
    self.mediaLengthLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.mediaLengthLabel];
    self.mediaLengthLabel.text = @"20:01"; // set default;

    // play forward
    self.backwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backwardButton.frame = CGRectMake((self.frame.size.width - btnWight * 3) / 2, labelHeight, btnWight, btnHeight);
    
    [self.backwardButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/cw_player_ctl_backward.png"] forState:UIControlStateNormal];
    [self.backwardButton addTarget:self action:@selector(backwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backwardButton];

    // play and pause
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(self.backwardButton.frame.origin.x + btnWight, labelHeight, btnWight, btnHeight);
    [self.playButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/cw_player_ctl_play.png"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/cw_player_ctl_pause.png"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];

    // play backward
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forwardButton.frame = CGRectMake(self.playButton.frame.origin.x + btnWight, labelHeight, btnWight, btnHeight);
    [self.forwardButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/cw_player_ctl_foward.png"] forState:UIControlStateNormal];
    [self.forwardButton addTarget:self action:@selector(forwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.forwardButton];

}

- (void)setDurationData:(CGFloat)duration
{
    _duration = duration;
    self.mediaLengthLabel.text = [self getPlaytimeBySecs:(int) self.duration];
}

// just minutes and secondes ,no hours
- (NSString *)getPlaytimeBySecs:(NSInteger)secs
{
    NSInteger m = secs / 60;
    NSInteger s = secs % 60;
    NSString *playtime = [NSString stringWithFormat:@"%.2d:%.2d", m, s];

    return playtime;
}

#pragma mark -
#pragma mark event to delegate

- (void)playButtonAction:(id)sender
{
    UIButton *button = (UIButton *) sender;

    if (!button.selected) {
        [self.slideControlDelegate play];

        // Add timer to track progress bar.
        if (!self.playbackTickTimer) {
            self.playbackTickTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playbackTick:) userInfo:nil repeats:YES];
            self.isPlaying = YES;
        }

        [button setSelected:YES];
    } else {
        [self.slideControlDelegate pause];
        [self.playbackTickTimer invalidate];
        self.playbackTickTimer = nil;
        self.isPlaying = NO;
        [button setSelected:NO];
    }
}

- (void)backwardButtonAction:(id)sender
{
    if ((self.currentPlayPosition - kMCSlideVideoPlayOffset) < 0) {
        self.currentPlayPosition = 0;
    } else {
        self.currentPlayPosition -= kMCSlideVideoPlayOffset;
    }

    [self.slideControlDelegate backward];
    [self updateSeekUI];
}

- (void)forwardButtonAction:(id)sender
{
    // Update current play postion.
    if ((self.currentPlayPosition + kMCSlideVideoPlayOffset) > self.duration) {
        self.currentPlayPosition = self.duration - 1.0;
    } else {
        self.currentPlayPosition += kMCSlideVideoPlayOffset;
    }

    [self.slideControlDelegate forward];

    [self updateSeekUI];
}

- (void)playbackTick:(id)sender
{
    if (self.currentPlayPosition + 1.f > self.duration) {
        [self trackFinished];
    } else {
        self.currentPlayPosition += 1.f;
        [self updateSeekUI];
    }
}

- (IBAction)sliderValueChanged:(id)sender
{
    self.currentPlayPosition = self.progressSlider.value * self.duration;
    [self.slideControlDelegate sliderChangedWithValue:self.currentPlayPosition];

    self.currentTimeLabel.text = [self getPlaytimeBySecs:(int) self.currentPlayPosition];
    //    [self updateSeekUI];
}

- (void)updateSeekUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
                       self.currentTimeLabel.text = [self getPlaytimeBySecs:(int) self.currentPlayPosition];
                       float playProgres = self.currentPlayPosition / (int) self.duration;
                       self.progressSlider.value = playProgres;
                   });
}

- (void)trackFinished
{
    self.isPlaying = NO;
    self.currentPlayPosition = 0;
    [self.playbackTickTimer invalidate];
    self.playbackTickTimer = nil;

    self.playButton.selected = NO;
    [self updateSeekUI];
    [self.slideControlDelegate playFinished];
}

#pragma mark -
#pragma mark set value


- (void)pause
{
    self.playButton.selected = NO;
    [self.playbackTickTimer invalidate];
    self.playbackTickTimer = nil;
    self.isPlaying = NO;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
