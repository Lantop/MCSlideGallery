//
//  MCSlideRemoteAudioView.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 10/11/14.
//  Copyright (c) 2014 Lanvige Jiang. All rights reserved.
//

#import "MCSlideBaseView.h"

#import <AVFoundation/AVFoundation.h>
#import "MCSlideControlDelegate.h"
@class MCSlideToolBarView;


@interface MCSlideRemoteAudioView : MCSlideBaseView <
    MCSlideControlDelegate
    >

- (void)toggleControlsView;
- (void)showControlView:(BOOL)animated;
- (void)hideControlView:(BOOL)animated;

@end