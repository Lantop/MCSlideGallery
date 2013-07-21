//
//  MCNavigationView.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/12/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCNavigationView.h"

@interface MCNavigationView ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *pagingButton;

@end


@implementation MCNavigationView

- (id)init
{
    if (self = [super init]) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGRect applicationRect = [UIScreen mainScreen].applicationFrame;
        CGRect navgationRect = CGRectMake(applicationRect.origin.x, applicationRect.origin.y, screenRect.size.height, 36);
        self.frame = navgationRect;
        NSLog(@"%@", [NSValue valueWithCGRect:navgationRect]);

        [self addSubview:self.backgroundView];
        [self addSubview:self.closeButton];
        [self addSubview:self.titleLabel];
        [self addSubview:self.pagingButton];
    }

    return self;
}

#pragma mark

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0.0, 0.0, 47, 36);
        [_closeButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_nav_close.png"]
                      forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(close:)
               forControlEvents:UIControlEventTouchUpInside];
    }

    return _closeButton;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        CGRect navRect = CGRectMake(0.f, 0.f, [[UIScreen mainScreen] bounds].size.height, 36);
        _backgroundView = [[UIView alloc] initWithFrame:navRect];
        NSLog(@"%@", [NSValue valueWithCGRect:navRect]);
        _backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_nav_bg.png"]];
    }
    
    return _backgroundView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGRect titleRect = CGRectMake(47, 0, [[UIScreen mainScreen] bounds].size.height - 94, 36);
        _titleLabel = [[UILabel alloc] initWithFrame:titleRect];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }

    return _titleLabel;
}

- (UIButton *)pagingButton
{
    if (!_pagingButton) {
        _pagingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pagingButton.frame = CGRectMake(self.frame.size.width - 58.0, 0.0, 58.f, 36);
        [_pagingButton setImage:[UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_nav_paging.png"]
                      forState:UIControlStateNormal];
        [_pagingButton addTarget:self
                          action:@selector(showPaging:)
                forControlEvents:UIControlEventTouchUpInside];
    }

    return _pagingButton;
}


#pragma mark -
#pragma mark Actions

- (void)close:(id)sender
{
    [self.delegate close];
}


- (void)showPaging:(id)sender
{
    [self.delegate showPaging];
}


#pragma mark -
#pragma mark Perproty

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}


#pragma mark -
#pragma mark 

- (void)show
{
    self.alpha = 0.7f;
}

- (void)hide
{
    self.alpha = 0;
}

@end
