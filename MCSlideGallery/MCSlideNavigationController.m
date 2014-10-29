//
//  MCSlideNavigationController.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 10/29/14.
//  Copyright (c) 2014 Lanvige Jiang. All rights reserved.
//

#import "MCSlideNavigationController.h"

@interface MCSlideNavigationController ()

@end

@implementation MCSlideNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


@end
