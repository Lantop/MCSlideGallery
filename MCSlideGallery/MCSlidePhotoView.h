//
//  MCSlidePhotoView.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideBaseView.h"
@class MCSlideMedia;

@interface MCSlidePhotoView : MCSlideBaseView <
    UIScrollViewDelegate
>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isZoomed;

- (void)resizeZoom;

@end