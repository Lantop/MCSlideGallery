//
//  MCSlideControlView.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSlideControlDelegate.h"

@interface MCSlideToolBarView : UIView

@property (nonatomic, weak) id <MCSlideControlDelegate> slideControlDelegate; // delegate for play control
@property (nonatomic, assign) CGFloat currentTime; // the current time
@property (nonatomic, assign) CGFloat duration; // the duration time
@property (nonatomic, assign) BOOL isPlaying;


- (void)play;
- (void)pause;
- (void)setProgressSliderWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;
- (void)updatePrgressSlider:(CGFloat)value;

@end
