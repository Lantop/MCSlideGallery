//
//  MCSlideVideoView.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideBaseView.h"
#import "MCSlideControlDelegate.h"
@class MCSlideControlView;

@interface MCSlideVideoView : MCSlideBaseView <
        MCSlideControlDelegate
        >

- (void)toggleControlView;
- (void)showControlView:(BOOL)animated;
- (void)hideControlView:(BOOL)animated;

@end
