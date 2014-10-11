//
//  MCSlideBaseView.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSlideViewTapDelegate.h"
@class MCSlideMedia;


@interface MCSlideBaseView : UIScrollView

@property (nonatomic, weak) id<MCSlideViewTapDelegate> viewTapDelegate;

- (id)initWithFrame:(CGRect)frame media:(MCSlideMedia *)media remote:(BOOL)remote;

@end
