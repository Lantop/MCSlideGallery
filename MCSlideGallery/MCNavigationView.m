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
@property (nonatomic, strong) UIButton *pagingButton;

@end


@implementation MCNavigationView

- (id)init
{
    self = [super init];

    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];

        CGRect applicationRect = [UIScreen mainScreen].applicationFrame;
        CGRect navgationRect = CGRectMake(applicationRect.origin.x, applicationRect.origin.y, screenRect.size.height, 44);
        self.frame = navgationRect;
        NSLog(@"%@", [NSValue valueWithCGRect:navgationRect]);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7f;

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
        UIImage *leftImg = [UIImage imageNamed:@"cw_navbar_back_nor"];
        _closeButton.frame = CGRectMake(20.0, 5.0, leftImg.size.width, leftImg.size.height);
        [_closeButton setImage:leftImg
                      forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(close:)
               forControlEvents:UIControlEventTouchUpInside];
    }

    return _closeButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 100.0) / 2, 0, 100.0, 44.0)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }

    return _titleLabel;
}

- (UIButton *)pagingButton
{
    if (!_pagingButton) {
        _pagingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *rightImg = [UIImage imageNamed:@"cw_navbar_paging_nor"];
        _pagingButton.frame = CGRectMake(self.frame.size.width - 20.0 - rightImg.size.width, 5.0, rightImg.size.width, rightImg.size.height);
        [_pagingButton setImage:rightImg
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
