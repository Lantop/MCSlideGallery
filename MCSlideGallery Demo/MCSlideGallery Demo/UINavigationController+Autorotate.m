//
//  UINavigationController+Autorotate.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/8/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "UINavigationController+Autorotate.h"

@implementation UINavigationController (Autorotate)

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
