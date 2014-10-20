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
#import <UIImageView+AFNetworking.h>
#import <MMProgressHUD.h>
#import <EXTScope.h>

@interface MCSlidePhotoView ()

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MCSlideMedia *media;
@property (nonatomic, assign) BOOL isZoomed;
@property (nonatomic, assign) BOOL isRemote;

@end


@implementation MCSlidePhotoView

- (id)initWithFrame:(CGRect)frame media:(MCSlideMedia *)media remote:(BOOL)remote
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
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.delegate = self;
        self.contentMode = UIViewContentModeCenter;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        self.decelerationRate = .85;
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);

        self.isRemote = remote;
        self.media = media;

        [self addSubview:self.imageView];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -

- (UIImageView *)imageView
{
    if (!_imageView) {
        CGRect recg = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _imageView = [[UIImageView alloc] initWithFrame:recg];

        NSURL *imageUrl = [NSURL URLWithString:self.media.resource];
        UIImage *defaultImage = [UIImage imageNamed:@"MCSlideGallery.bundle/mcslide_image_default.png"];

        // Set resource
        if (self.isRemote) {



            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.center = _imageView.center;

            [_imageView addSubview:indicatorView];

            [indicatorView startAnimating];


            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageUrl];
//            @weakify(self)
            [_imageView setImageWithURLRequest:imageRequest placeholderImage:defaultImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                @strongify(self)
                _imageView.image = image;
                [indicatorView removeFromSuperview];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                [indicatorView removeFromSuperview];
            }];
        } else {
            UIImage *image = [UIImage imageWithContentsOfFile:self.media.resource];
            if (image) {
                [_imageView setImage:image];
            }
            else {
                [_imageView setImage:defaultImage];
            }
        }
    }

    return _imageView;
}


- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _loadingView.center = self.center;
        _loadingView.backgroundColor = [UIColor darkGrayColor];
        _loadingView.alpha = .7f;

        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.frame = CGRectMake(31.5f, 31.5f, 37, 37);

        NSLog(@"%@", NSStringFromCGRect(indicatorView.frame));
        [_loadingView addSubview:indicatorView];

        [indicatorView startAnimating];
    }

    return _loadingView;
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

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
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
