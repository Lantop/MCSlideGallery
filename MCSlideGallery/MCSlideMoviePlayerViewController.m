//
//  MCSlideMoviePlayerViewController.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideMoviePlayerViewController.h"

@implementation MCSlideMoviePlayerViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.view.frame = CGRectMake(0, 0, screenRect.size.height, screenRect.size.width);
        self.view.transform = CGAffineTransformIdentity;
        self.moviePlayer.shouldAutoplay = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
