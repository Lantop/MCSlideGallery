//
//  MCSlidePagingView.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlidePagingView.h"
#import <QuartzCore/QuartzCore.h>
#import "MCSlideMedia.h"
#import "MCSlidePagingCell.h"

@interface MCSlidePagingView ()

@property (nonatomic, strong) NSArray *sourceData;


@end

@implementation MCSlidePagingView

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (id)initWithFrame:(CGRect)frame Source:(NSArray *)source
{
    self = [super initWithFrame:frame];

    if (self) {
        _currentPage = 0;
        self.dataSource = self;
        self.delegate = self;
        self.sourceData = source;
        self.layer.cornerRadius = .5f;
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.alpha = .8f;
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return self;
}


// 返回一个NsInterger作为行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource) {
        return [self.sourceData count];
    } else {
        return 0;
    }
}

// 每个cell显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *chapterIndentifier = @"mcslidePagingCell";
    MCSlidePagingCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterIndentifier];

    if (nil == cell) {
        cell = [[MCSlidePagingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chapterIndentifier];
    }

    if ([self.sourceData count] > row) {
        MCSlideMedia *media = [self.sourceData objectAtIndex:row];
        UIImage *icon = [UIImage imageWithContentsOfFile:media.thumbnail];

        if (icon) {
            cell.iconImageView.image = icon;
        } else {
            cell.iconImageView.image = [UIImage imageNamed:@"mcslide_audio_thumnail_default.png"];
        }
    }

    cell.rankingLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];

    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.f;
}

#pragma mark -
#pragma mark Table delegate
// cell的选定事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.pagingDelegate gotoSlide:indexPath.row animated:YES];
}

@end
