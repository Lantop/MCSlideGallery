//
//  MCSlidePagingCell.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 6/28/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlidePagingCell.h"

@interface MCSlidePagingCell ()

@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *leftMiddleView;

@end


@implementation MCSlidePagingCell

- (UIView*)middleView {
    if (!_middleView) {
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(5.f, 5.f, 75.f, 50.f)];
        _middleView.backgroundColor = [UIColor whiteColor];
    }
    return _middleView;
}

- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.f, 7.f, 71.f, 46.f)];
        _iconImageView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}

- (UIView*)leftMiddleView {
    if (!_leftMiddleView) {
        _leftMiddleView = [[UIView alloc] initWithFrame:CGRectMake(7.f, 7.f, 26.f, 46.f)];
        _leftMiddleView.backgroundColor = [UIColor blackColor];
        _leftMiddleView.alpha = .8f;
    }
    return _leftMiddleView;
}

- (UILabel *)rankingLabel {
    if (!_rankingLabel) {
        _rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.f, 10.f, 26.f, 35.f)];
        _rankingLabel.backgroundColor = [UIColor clearColor];
        _rankingLabel.font = [UIFont boldSystemFontOfSize:16];
        _rankingLabel.textColor = [UIColor whiteColor];
        _rankingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankingLabel;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.middleView];
        [self addSubview:self.iconImageView];
        [self addSubview:self.leftMiddleView];
        [self addSubview:self.rankingLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.middleView.backgroundColor = [UIColor colorWithRed:242.f/255.f green:117.f/255.f blue:132.f/255.f alpha:1.f];
    }else {
        self.middleView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.middleView.backgroundColor = [UIColor colorWithRed:242.f/255.f green:117.f/255.f blue:132.f/255.f alpha:1.f];
    }else {
        self.middleView.backgroundColor = [UIColor whiteColor];
    }
}

@end
