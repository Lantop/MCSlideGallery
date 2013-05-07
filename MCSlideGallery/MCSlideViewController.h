//
//  MCSlideViewController.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCSlideViewController : NSObject

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *galleryViews;

@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) BOOL isFullScreen;


- (void)gotoPageByIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)previous;
- (void)next;
- (IBAction)currentPageChanged:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil dataSource:(NSArray *)dataSource;

@end
