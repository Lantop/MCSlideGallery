//
//  MCSlideBaseView.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideBaseView.h"
#import "MCSlideMedia.h"

@implementation MCSlideBaseView

- (id)initWithFrame:(CGRect)frame withMedia:(MCSlideMedia *)media
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
    }
    
    return self;
}

#pragma mark -
#pragma mark touch event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.viewTapDelegate respondsToSelector:@selector(didTapOnView:)]) {
        [self.viewTapDelegate didTapOnView:self];
    }
}

@end
