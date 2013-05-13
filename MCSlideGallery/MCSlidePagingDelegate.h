//
//  MCSlidePagingDelegate.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/12/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCSlidePagingDelegate <NSObject>

- (void)gotoSlide:(NSUInteger)index animated:(BOOL)animated;
- (void)previous;
- (void)next;

@end
