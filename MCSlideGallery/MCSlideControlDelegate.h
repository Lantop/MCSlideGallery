//
//  MCSlideControlDelegate.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCSlideControlDelegate <NSObject>

@required
- (void)play; // play or pause button
- (void)pause; // play or pause button
- (void)backward; // play backward
- (void)forward;  // play forward button
- (void)sliderChangedWithValue:(CGFloat)value; // slider

@optional
- (void)playFinished;

@end
