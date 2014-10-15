//
//  MCSlideViewController.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideViewController.h"
#import "MCSlideDefines.h"
#import "MCSlideMedia.h"
#import "MCSlideBaseView.h"
#import "MCSlidePhotoView.h"
#import "MCSlideAudioView.h"
#import "MCSlideVideoView.h"
#import "MCNavigationView.h"
#import "MCSlidePagingView.h"

@interface MCSlideViewController ()

@property (nonatomic, strong) MCNavigationView *navigationView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *galleryViews;
@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) MCSlidePagingView *pagingView;
@property (nonatomic, assign) BOOL isPaging;
@property (nonatomic, assign) BOOL isRemote;

- (void)enterFullscreen;

@end


@implementation MCSlideViewController

- (id)initWithMediaData:(NSArray *)data remote:(BOOL)remte
{
    self = [super init];

    if (self) {
        // Custom initialization
        self.dataSource = data;
        self.isRemote = remte;

        self.galleryViews = [[NSMutableDictionary alloc] init];

        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;

        self.numberOfPages = self.dataSource.count;
        self.currentPage = 0;
        

        // Layout the view and content.
        [self positionScrollView];
        [self updateScrollViewContentSize];
        [self buildGalleryViews];

        [self.view addSubview:self.scrollView];

        self.navigationView = [[MCNavigationView alloc] init];
        self.navigationView.delegate = self;
        [self.view addSubview:self.navigationView];
        [self refreshTitle];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    // Set status bar style.
    self.wantsFullScreenLayout = YES; 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    // 设置应用程序的状态栏到指定的方向
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    // view旋转
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
//    // 显示状态栏 状态栏旋转
////    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//    
//    // 显示navigationController
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showPagingPopTableView
{
}

#pragma mark -
#pragma mark layout the view

- (void)positionScrollView
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect scrollerRect = CGRectZero;

    scrollerRect = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
    self.scrollView.frame = scrollerRect;
}

- (void)updateScrollViewContentSize
{
    float contentWidth = self.scrollView.frame.size.width * self.numberOfPages;

    [self.scrollView setContentSize:CGSizeMake(contentWidth, self.scrollView.frame.size.height)];
}

#pragma mark -
#pragma mark Build photo views

// creates all the image views for this gallery
- (void)buildGalleryViews
{
    NSUInteger i, count = self.numberOfPages;

    for (i = 0; i < count; i++) {
        MCSlideMedia *media = self.dataSource[i];
        CGFloat frameWidth = self.scrollView.frame.size.width;
        CGRect viewRect = CGRectMake(frameWidth * i, 0, frameWidth, self.scrollView.frame.size.height);

        MCSlideBaseView *slideView;

        switch (media.mediaType) {
            case MCSlideMediaTypePhoto: {
                slideView = [[MCSlidePhotoView alloc] initWithFrame:viewRect media:media remote:self.isRemote];
                break;
            }
            case MCSlideMediaTypeAudio: {
                slideView = [[MCSlideAudioView alloc] initWithFrame:viewRect media:media remote:self.isRemote];
                break;
            }
            case MCSlideMediaTypeVideo: {
                slideView = [[MCSlideVideoView alloc] initWithFrame:viewRect media:media remote:self.isRemote];
                break;
            }

            default:
                break;
        }

        slideView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        slideView.autoresizesSubviews = YES;
        slideView.viewTapDelegate = self;

        // set page changed delegate
        [self.scrollView addSubview:slideView];
        [self.galleryViews setObject:slideView forKey:[NSNumber numberWithUnsignedInteger:i]];
    }
}

#pragma mark -
#pragma mark Set screen autorotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark -
#pragma mark View delegate, tap

- (void)didTapOnView:(MCSlidePhotoView *)galleryView
{
    [self toggleFullScreen];
}


#pragma mark -
#pragma mark MCSlidePagingDelegate Methods

- (void)moveScrollerToIndex:(NSUInteger)index WithAnimation:(BOOL)animation
{
    int xp = self.scrollView.frame.size.width * index;
    
    [self.scrollView scrollRectToVisible:CGRectMake(xp, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:animation];
//    self.isScrolling = animation;
    
    [self currentPageChanged];
}

- (void)gotoSlide:(NSUInteger)index animated:(BOOL)animated
{
    self.currentPage = index;
    [self moveScrollerToIndex:index WithAnimation:animated];
}

- (void)previous
{
    self.currentPage--;
    [self moveScrollerToIndex:self.currentPage WithAnimation:YES];
}

- (void)next
{
    self.currentPage++;
    [self moveScrollerToIndex:self.currentPage WithAnimation:YES];
}

#pragma mark -
#pragma mark Fullscreen

- (void)enableAppInteraction
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)disableAppInteraction
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)toggleFullScreen
{
    if (self.isScrolling) {
        return;
    }
    
    if (self.isPaging) {
        [self showPaging];
        return;
    }

    // toggle fullscreen.
    if (self.isFullScreen == NO) {
        [self enterFullscreen];
    } else {
        [self exitFullscreen];
    }
}

- (void)enterFullscreen
{
    if (self.isFullScreen) {
        return;
    }
    
    self.isFullScreen = YES;
    [self disableAppInteraction];

    [UIView animateWithDuration:.5f animations:^{
        [self.navigationView hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMCSlideViewWillEnterFullScreenNotification
                                                             object:self];
        [self enableAppInteraction];
     }];
}

- (void)exitFullscreen
{
    if (!self.isFullScreen) {
        return;
    }
    
    self.isFullScreen = NO;
    [self disableAppInteraction];

    [UIView animateWithDuration:0.5f animations:^{
        [self.navigationView show];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMCSlideViewWillExitFullScreenNotification
                                                             object:self];
        [self enableAppInteraction];
     }];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.isScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollingHasEnded];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollingHasEnded];
}

- (void)scrollingHasEnded
{
    self.isScrolling = NO;

    NSUInteger newIndex = floor(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);

    // don't proceed if the user has been scrolling, but didn't really go anywhere.
    if (newIndex == self.currentPage) {
        return;
    }

    // clear previous
    self.currentPage = newIndex;

    // force not show fullscreen when the new page is media page.
    MCSlideMedia *media = self.dataSource[newIndex];

    if (media.mediaType == MCSlideMediaTypeAudio || media.mediaType == MCSlideMediaTypeVideo) {
        [self exitFullscreen];
    }

    
    [self currentPageChanged];
}


#pragma mark -
#pragma mark MCSlideNavigationViewDelegate Methods

- (void)close
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMCSlideViewWillCloseNotification object:self];

    // 显示状态栏 状态栏旋转
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // show navigationController
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    // Pop
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPaging
{
    if (!_pagingView) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGRect pagingViewFrame = CGRectMake(screenRect.size.height - 85.0, 36.0, 85.f, screenRect.size.width - 36.f);
        
        _pagingView = [[MCSlidePagingView alloc] initWithFrame:pagingViewFrame Source:self.dataSource];
        _pagingView.pagingDelegate = self;
        _pagingView.currentPage = self.currentPage;
        [self.view addSubview:_pagingView];
        _pagingView.hidden = YES;
    }
    _pagingView.hidden = !_pagingView.hidden;
    self.isPaging = !self.pagingView.hidden;
}

#pragma mark -
#pragma mark PageControl stuff

// FIXME: why can't get the event from page control current page changed?
- (void)currentPageChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMCSlidePageChangedNotification
                                                        object:self];

    // change title
    [self refreshTitle];
}


- (void)refreshTitle
{
    NSString *title = [NSString stringWithFormat:@"(%ld/%d)%@",
                       self.currentPage + 1,
                       self.numberOfPages,
                       ((MCSlideMedia *) self.dataSource[self.currentPage]).title];

    self.navigationView.title = title;
}

@end

