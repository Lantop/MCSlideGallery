//
//  MCSlidePagingCell.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 6/28/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlidePagingCell.h"

@implementation MCSlidePagingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.imageView addSubview:self.rankingLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UILabel *)rankingLabel
{
    if (!_rankingLabel) {
        _rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 4, 16, 8)];
        _rankingLabel.backgroundColor = [UIColor clearColor];
        _rankingLabel.font = [UIFont boldSystemFontOfSize:11];
        _rankingLabel.textColor = [UIColor whiteColor];
        _rankingLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _rankingLabel;
}

@end
