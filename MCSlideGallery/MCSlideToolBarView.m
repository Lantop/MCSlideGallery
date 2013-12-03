//
//  MCSlideControlView.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideToolBarView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MCSlideDefines.h"

static const NSInteger labelHeight = 20.0; // current and count time label height
static const NSInteger labelWight = 60.0; // current and count time label wight
static const NSInteger btnHeight = 60.0; // forward playpause backward button height
static const NSInteger btnWight = 80.0; // forward playpause backward button wight
static const CGFloat kToolBarHeight = 40.f;

@interface MCSlideToolBarView ()

@property (nonatomic, strong) UIImageView *controlerView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UISlider *progressSlider;  // play progress
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *playbackTickTimer;  // time to refresh slider and current time label


@end


@implementation MCSlideToolBarView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self viewInit];

        // add observer to notificationcenter for playing finished
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(trackFinished)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewInit
{
    self.backgroundColor = [UIColor grayColor];
    self.alpha = 0.8;

    [self addSubview:self.controlPartView];
    [self addSubview:self.progressSlider];
    [self addSubview:self.timeLabel];
//
//
//    // count time
//    self.mediaLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - labelWight, 0.0, labelWight, labelHeight)];
//    self.mediaLengthLabel.font = [UIFont systemFontOfSize:14.0];
//    self.mediaLengthLabel.textColor = [UIColor whiteColor];
//    self.mediaLengthLabel.backgroundColor = [UIColor clearColor];
//    self.mediaLengthLabel.textAlignment = NSTextAlignmentRight;
//    [self addSubview:self.mediaLengthLabel];
//    self.mediaLengthLabel.text = @"20:01"; // set default;
}


- (UIImageView *)controlPartView
{
    if (!_controlerView) {
        _controlerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 155.f, 40.f)];
        _controlerView.image = [UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_toolbar_controller_bg.png"];
        _controlerView.userInteractionEnabled = YES;
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // self.playButton.imageEdgeInsets = UIEdgeInsetsMake(8.f, 23.f, 0, 0);
        self.playButton.frame = CGRectMake(0.f, 0.f, 54.f, 40.f);
        [self.playButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_toolbar_controller_play.png"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_toolbar_controller_play_sel.png"] forState:UIControlStateSelected];
        [self.playButton addTarget:self
                            action:@selector(playButtonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        [_controlerView addSubview:self.playButton];
        
        UIButton *backwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backwardButton.frame = CGRectMake(55.f, 0.f, 50.f, 40.f);
        [backwardButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_toolbar_controller_backward.png"] forState:UIControlStateNormal];
        [backwardButton addTarget:self
                       action:@selector(backwardButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
        [_controlerView addSubview:backwardButton];
        
        UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        forwardButton.frame = CGRectMake(105.f, 0.f, 50.f, 40.f);
        [forwardButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_toolbar_controller_forward.png"] forState:UIControlStateNormal];
        [forwardButton addTarget:self
                           action:@selector(forwardButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
        [_controlerView addSubview:forwardButton];
    }
    
    return _controlerView;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        // play slider
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(172.f, 10.f, self.frame.size.width - 190.f, 12.f)];
    
        UIImage *slidePassedImage = [UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_toolbar_slider_passed.png"];
        UIImage *slideLeftImage = [UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_toolbar_slider_left.png"];
        [_progressSlider setMinimumTrackImage:slidePassedImage forState:UIControlStateNormal];
        [_progressSlider setMaximumTrackImage:slideLeftImage forState:UIControlStateNormal];
        
        UIImage *indicatorImage = [UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_toolbar_controller_indicator.png"];
        [_progressSlider setThumbImage:indicatorImage forState:UIControlStateNormal];
        
        
        [_progressSlider addTarget:self
                            action:@selector(sliderValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
        _progressSlider.backgroundColor = [UIColor clearColor];
    }
    
    return _progressSlider;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 120.f, 5.0, 100.f, 14.f)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:11.0];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = MCSTextAlignmentRight;
        _timeLabel.text = @"00:00/00:00"; // set default
    }
    
    return _timeLabel;
}

- (void)setDurationData:(CGFloat)duration
{
    _duration = duration;
    self.timeLabel.text = [self timeLabelString];
}

- (NSString *)timeLabelString
{
    return [NSString stringWithFormat:@"%@/%@", [self getFormattedTimeString:self.currentPlayPosition], [self getFormattedTimeString:self.duration]];
}

// just minutes and secondes ,no hours
- (NSString *)getFormattedTimeString:(NSInteger)seconds
{
    NSInteger m = seconds / 60;
    NSInteger s = seconds % 60;
    NSString *playtime = [NSString stringWithFormat:@"%.2d:%.2d", m, s];

    return playtime;
}

#pragma mark -
#pragma mark event to delegate

- (IBAction)playButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;

    if (!button.selected) {
        [self.slideControlDelegate play];

        // Add timer to track progress bar.
        if (!self.playbackTickTimer) {
            self.playbackTickTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playbackTick:) userInfo:nil repeats:YES];
            self.isPlaying = YES;
        }

        button.selected = YES;
    } else {
        [self.slideControlDelegate pause];
        [self.playbackTickTimer invalidate];
        self.playbackTickTimer = nil;
        self.isPlaying = NO;
        button.selected = NO;
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

    self.timeLabel.text = [self timeLabelString];
    //    [self updateSeekUI];
}

- (void)updateSeekUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
                       self.timeLabel.text = [self timeLabelString];
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

- (void)play {
    self.playButton.selected = YES;
    [self playButtonAction:nil];
}

- (void)pause {
    self.playButton.selected = NO;
    [self.playbackTickTimer invalidate];
    self.playbackTickTimer = nil;
    self.isPlaying = NO;
}

@end
