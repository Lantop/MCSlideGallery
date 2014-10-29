//
//  MCSlidePagingView.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSlidePagingDelegate.h"

@interface MCSlidePagingView : UITableView <
        UITableViewDataSource,
        UITableViewDelegate
        >

@property (nonatomic, weak) id<MCSlidePagingDelegate> pagingDelegate;
@property (nonatomic, assign) NSInteger currentPage;

//- (id)initWithFrame:(CGRect)frame source:(NSArray *)source;
- (id)initWithFrame:(CGRect)frame source:(NSArray *)source remote:(BOOL)remote;

@end
