//
//  UINavigationController+Autorotate.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/8/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Autorotate)

- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
