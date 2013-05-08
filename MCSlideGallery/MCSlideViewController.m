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

@interface MCSlideViewController ()

@property (nonatomic, assign) BOOL didTrans;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *navBtnLeft;
@property (nonatomic, strong) UILabel *navLabelTitle;
@property (nonatomic, strong) UIButton *navBtnRight;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;

- (void)enterFullscreen;

@end


@implementation MCSlideViewController

- (id)initWithMediaData:(NSArray *)data
{
    self = [super init];

    if (self) {
        // Custom initialization
        self.dataSource = data;

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
        [self navInit];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self becomeActive];
    
    // 隐藏navigationController
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    // 显示navigationController
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)becomeActive
{
    if (!self.didTrans) {
        [self setOrientation:UIInterfaceOrientationLandscapeRight];
        self.didTrans = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationFade];
    }

    [self performSelector:@selector(hideStatusBar)
               withObject:nil
               afterDelay:0.0];
}

- (void)hideStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //设置应用程序的状态栏到指定的方向
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    //view旋转
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    
    self.didTrans = NO;
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(regisnActive)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self regisnActive];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)regisnActive
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)navInit
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.height, 44)];
    self.navView.backgroundColor = [UIColor blackColor];
    self.navView.alpha = 0.7f;
    [self.view addSubview:self.navView];

    self.navBtnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImg = [UIImage imageNamed:@"cw_navbar_back_nor"];
    self.navBtnLeft.frame = CGRectMake(20.0, 5.0, leftImg.size.width, leftImg.size.height);
    [self.navBtnLeft setImage:leftImg forState:UIControlStateNormal];
    [self.navBtnLeft addTarget:self action:@selector(pullBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.navBtnLeft];

    self.navLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake((screenRect.size.height - 100.0) / 2, 0, 100.0, 44.0)];
    self.navLabelTitle.backgroundColor = [UIColor clearColor];
    self.navLabelTitle.textColor = [UIColor whiteColor];
    self.navLabelTitle.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:self.navLabelTitle];
    [self refreshTitle];

    self.navBtnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *rightImg = [UIImage imageNamed:@"cw_navbar_paging_nor"];
    self.navBtnRight.frame = CGRectMake(screenRect.size.height - 20.0 - rightImg.size.width, 5.0, rightImg.size.width, rightImg.size.height);
    [self.navBtnRight setImage:rightImg forState:UIControlStateNormal];
    [self.navBtnRight addTarget:self action:@selector(showPagingPopTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.navBtnRight];
}

- (void)pullBack
{
    //    [self pageClosedDelegateChain];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMCSlideViewWillCloseNotification object:self];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];

    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
    
    //状态栏旋转
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showPagingPopTableView
{
//    if (!self.chapterTableView) {
//        CGRect screenRect = [[UIScreen mainScreen] bounds];
//        CGRect chapterFrame = CGRectMake(screenRect.size.height - 250.0, 50.0, 220, 200.0);
//
//        self.chapterTableView = [[MCGridView alloc] initWithFrame:chapterFrame withSource:self.dataSource withType:MCGridViewTypeMix];
//        self.chapterTableView.delegateMCGrid = self;
//        [self.view addSubview:self.chapterTableView];
//        self.chapterTableView.hidden = YES;
//    }
//
//    self.chapterTableView.hidden = !self.chapterTableView.hidden;
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
#pragma mark private action

- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    [self.view setFrame:CGRectMake(0, 0, screenRect.size.height, screenRect.size.width)];

    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.transform = CGAffineTransformMakeRotation(M_PI * 1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        self.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.view.transform = CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationPortrait) {
        self.view.transform = CGAffineTransformIdentity;
    }

    int device = UIDeviceOrientationPortrait + (orientation - UIInterfaceOrientationPortrait);
    [[UIApplication sharedApplication] setStatusBarOrientation:device animated:YES];
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
                slideView = [[MCSlidePhotoView alloc] initWithFrame:viewRect withMedia:media];
                break;
            }
            case MCSlideMediaTypeAudio: {
                slideView = [[MCSlideAudioView alloc] initWithFrame:viewRect withMedia:media];
                break;
            }
            case MCSlideMediaTypeVideo: {
                slideView = [[MCSlideAudioView alloc] initWithFrame:viewRect withMedia:media];
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
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return 0;
}

#pragma mark -
#pragma mark View delegate, tap

- (void)didTapOnView:(MCSlidePhotoView *)galleryView
{
//    if (self.chapterTableView && !self.chapterTableView.hidden) {
//        // Close paging view
//        self.chapterTableView.hidden = YES;
//    } else {
//        [self toggleFullScreen];
//    }
}

#pragma mark -
#pragma mark MCGride View Delegate

// - (void)MCGridViewDidSelect:(MCGridView *)gridview
// {
//    NSInteger index = gridview.gridSelIndex;
//
//    [self gotoPageByIndex:index animated:YES];
//    self.chapterTableView.hidden = YES;
//    self.pageControl.currentPage = index;
//    [self currentPageChanged:nil];
// }

#pragma mark -
#pragma mark scrolling page event

- (void)gotoSlide:(NSUInteger)index animated:(BOOL)animated
{
    self.currentPage = index;
    [self moveScrollerToIndex:index WithAnimation:animated];
}

- (void)previous
{
}

- (void)next
{
}

#pragma mark -
#pragma mark page

- (void)moveScrollerToIndex:(NSUInteger)index WithAnimation:(BOOL)animation
{
    int xp = self.scrollView.frame.size.width * index;

    [self.scrollView scrollRectToVisible:CGRectMake(xp, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:animation];
    self.isScrolling = animation;
}

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

    // toggle fullscreen.
    if (self.isFullScreen == NO) {
        [self enterFullscreen];
    } else {
        [self exitFullscreen];
    }
}

- (void)enterFullscreen
{
    self.isFullScreen = YES;
    [self disableAppInteraction];

    [UIView animateWithDuration:.5f animations:^{
         self.navView.alpha = 0.0;
         [[NSNotificationCenter defaultCenter] postNotificationName:kMCSlideViewWillEnterFullScreenNotification
                                                             object:self];
         [self enableAppInteraction];
     }];
}

- (void)exitFullscreen
{
    self.isFullScreen = NO;
    [self disableAppInteraction];

    [UIView animateWithDuration:0.5f animations:^{
         self.navView.alpha = .5;
         [[NSNotificationCenter defaultCenter] postNotificationName:kMCSlideViewWillExitFullScreenNotification
                                                             object:self];
         [self enableAppInteraction];
     }];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff

#pragma mark -
#pragma mark Scroll view delegate

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

    // Fixme: remove this line when fix the issue below.
    [self currentPageChanged:nil];
}


#pragma mark -
#pragma mark PageControl stuff

// FIXME: why can't get the event from page control current page changed?
- (IBAction)currentPageChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMCSlidePageChangedNotification
                                                        object:self];

    // change title
    [self refreshTitle];
}


- (void)refreshTitle
{
    NSString *title = [NSString stringWithFormat:@"(%d/%d)%@",
                       self.currentPage + 1,
                       self.numberOfPages,
                       ((MCSlideMedia *) self.dataSource[self.currentPage]).title];

    self.navLabelTitle.text = title;
}

@end

