//
//  MCSlideAudioView.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideBaseView.h"
#import <AVFoundation/AVFoundation.h>
#import "MCSlideControlDelegate.h"
@class MCSlideControlView;

@interface MCSlideAudioView : MCSlideBaseView <
        AVAudioPlayerDelegate,
        MCSlideControlDelegate
        >

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) MCSlideControlView *controlView;
@property (nonatomic, strong) UIImageView *noteView;

- (void)toggleControlsView;
- (void)showControlView:(BOOL)animated;
- (void)hideControlView:(BOOL)animated;

@end
