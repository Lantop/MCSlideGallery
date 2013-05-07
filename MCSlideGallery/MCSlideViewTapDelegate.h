//
//  MCGalleryViewTapDelegate.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCSlideBaseView;

@protocol MCSlideViewTapDelegate <NSObject>
// indicates single touch and allows controller repsond and go toggle fullscreen
- (void)didTapOnView:(MCSlideBaseView *)galleryView;
@end
