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

- (id)initWithFrame:(CGRect)frame Source:(NSArray *)source
{
    self = [super initWithFrame:frame];

    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.sourceData = source;
        self.layer.opacity = .8f;
        self.layer.cornerRadius = .5f;
        self.backgroundColor = [UIColor blackColor];
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
            cell.imageView.image = icon;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"mcslide_audio_thumnail_default.png"];
        }
    }

    cell.rankingLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];

    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.f;
}

#pragma mark -
#pragma mark Table delegate
// cell的选定事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.pagingDelegate gotoSlide:indexPath.row animated:YES];
}

@end
