//
//  MCGalleryDefines.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

extern CGFloat const kMCSlideVideoPlayOffset; // forward and backward time is 5.0s

// Notification Key
extern NSString *const kMCSlideViewWillEnterFullScreenNotification;
extern NSString *const kMCSlideViewWillExitFullScreenNotification;
extern NSString *const kMCSlidePageChangedNotification;
extern NSString *const kMCSlideViewWillCloseNotification;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define MCSTextAlignmentLeft NSTextAlignmentLeft
#define MCSTextAlignmentCenter NSTextAlignmentCenter
#define MCSTextAlignmentRight NSTextAlignmentRight
#define MCSLineBreakByWordWrapping NSLineBreakByWordWrapping
#else
#define MCSTextAlignmentLeft UITextAlignmentLeft
#define MCSTextAlignmentCenter UITextAlignmentCenter
#define MCSTextAlignmentRight UITextAlignmentRight
#define MCSLineBreakByWordWrapping UILineBreakModeWordWrap
#endif

