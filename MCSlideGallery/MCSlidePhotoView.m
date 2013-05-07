//
//  MCSlidePhotoView.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlidePhotoView.h"
#import "MCSlideMedia.h"
#import "MCSlideDefines.h"

@implementation MCSlidePhotoView

- (id)initWithFrame:(CGRect)frame withMedia:(MCSlideMedia *)media
{
    self = [super initWithFrame:frame];

    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pageChanged)
                                                     name:kMCSlidePageChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pageClosed)
                                                     name:kMCSlideViewWillCloseNotification
                                                   object:nil];

        // Initialization code
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.delegate = self;
        self.contentMode = UIViewContentModeCenter;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        self.decelerationRate = .85;
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);

        self.imageView = [[UIImageView alloc] initWithFrame:rect];

        UIImage *image = [UIImage imageWithContentsOfFile:media.resource];

        if (image) {
            [self.imageView setImage:image];
        } else {
            [self.imageView setImage:[UIImage imageNamed:@"gallery_img_default.jpg"]];
        }

        [self addSubview:self.imageView];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Tap event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}


#pragma mark -
#pragma mark Zoom event stuff

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (self.zoomScale == self.minimumZoomScale) {
        self.isZoomed = NO;
    } else {
        self.isZoomed = YES;
    }
}

- (void)resizeZoom
{
    self.isZoomed = NO;
    [self setZoomScale:self.minimumZoomScale animated:NO];
    [self zoomToRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) animated:NO];
    self.contentSize = CGSizeMake(self.frame.size.width * self.zoomScale, self.frame.size.height * self.zoomScale);
}


#pragma mark -
#pragma mark page changed event

- (void)pageChanged
{
    [self resizeZoom];
}

- (void)pageClosed
{
}

@end
