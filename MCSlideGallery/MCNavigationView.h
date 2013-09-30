//
//  MCNavigationView.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/12/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSlideNavigationViewDelegate.h"
#import "MCSlideDefines.h"


@interface MCNavigationView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id<MCSlideNavigationViewDelegate> delegate;

- (void)show;
- (void)hide;

@end
