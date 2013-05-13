//
//  MCSlideViewController.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCSlideViewTapDelegate.h"
#import "MCSlidePagingDelegate.h"
#import "MCSlideNavigationViewDelegate.h"

@interface MCSlideViewController : UIViewController <
        UIScrollViewDelegate,
        MCSlideNavigationViewDelegate,
        MCSlidePagingDelegate,
        MCSlideViewTapDelegate
        >

- (id)initWithMediaData:(NSArray *)data;

@end
