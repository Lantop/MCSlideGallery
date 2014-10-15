//
//  ViewController.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "ViewController.h"
#import "MCSlideGallery.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openButtonAction:(id)sender
{
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"hawaii" ofType:@"jpg"];
    MCSlideMedia *m1 = [[MCSlideMedia alloc] initWithTitle:@"hawaii"
                                                 mediaType:MCSlideMediaTypePhoto
                                                  resource:path1
                                              illustration:@"Hawaii"
                                                 thumbnail:path1];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"sushi" ofType:@"jpg"];
    MCSlideMedia *m2 = [[MCSlideMedia alloc] initWithTitle:@"sushi"
                                                 mediaType:MCSlideMediaTypePhoto
                                                  resource:path2
                                              illustration:@"sushi"
                                                 thumbnail:path2];
    
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"lava" ofType:@"jpg"];
    MCSlideMedia *m3 = [[MCSlideMedia alloc] initWithTitle:@"lava"
                                                 mediaType:MCSlideMediaTypePhoto
                                                  resource:path3
                                              illustration:@"lava"
                                                 thumbnail:path3];
    
    NSString *path4 = [[NSBundle mainBundle] pathForResource:@"hourse" ofType:@"mp4"];
//    NSString *path4 = @"http://s1.lan-top.cn/res/wkt/2.mp4";
    MCSlideMedia *m4 = [[MCSlideMedia alloc] initWithTitle:@"hourse"
                                                 mediaType:MCSlideMediaTypeVideo
                                                  resource:path4
                                              illustration:path3
                                                 thumbnail:path3];
    
    NSString *path5 = [[NSBundle mainBundle] pathForResource:@"canon" ofType:@"mp3"];
    MCSlideMedia *m5 = [[MCSlideMedia alloc] initWithTitle:@"canon"
                                                 mediaType:MCSlideMediaTypeAudio
                                                  resource:path5
                                              illustration:path3
                                                 thumbnail:path1];
    
    NSArray *medias = @[m1, m2, m5, m3, m4];
    
    MCSlideViewController *slideViewControllor = [[MCSlideViewController alloc] initWithMediaData:medias remote:false];
    
    [self.navigationController pushViewController:slideViewControllor animated:YES];
}

- (IBAction)openRemoteAction:(id)sender
{
    NSString *path1 = @"http://s1.lan-top.cn/res/data/coursewarePkg/output/7798/pic/7798_20140923145533_1.jpg";
    MCSlideMedia *m1 = [[MCSlideMedia alloc] initWithTitle:@"hawaii"
                                                 mediaType:MCSlideMediaTypePhoto
                                                  resource:path1
                                              illustration:@"Hawaii"
                                                 thumbnail:path1];

    NSString *path2 = @"http://s1.lan-top.cn/res/data/coursewarePkg/output/7798/pic/7798_20140923145533_3.jpg";
    MCSlideMedia *m2 = [[MCSlideMedia alloc] initWithTitle:@"sushi"
                                                 mediaType:MCSlideMediaTypePhoto
                                                  resource:path2
                                              illustration:@"sushi"
                                                 thumbnail:path2];

    NSString *path3 = @"http://s1.lan-top.cn/res/data/coursewarePkg/output/7798/pic/7798_20140923145533_4.jpg";
    MCSlideMedia *m3 = [[MCSlideMedia alloc] initWithTitle:@"lava"
                                                 mediaType:MCSlideMediaTypePhoto
                                                  resource:path3
                                              illustration:@"lava"
                                                 thumbnail:path3];

//    NSString *path4 = @"https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8";
//    NSString *path4 = @"http://s1.lan-top.cn/res/wkt/2.mp4";
    NSString *path4 = @"http://s1.lan-top.cn/res/data/coursewarePkg/output/4041/4041_77646_2_1385351840344.mp4";
    MCSlideMedia *m4 = [[MCSlideMedia alloc] initWithTitle:@"hourse"
                                                 mediaType:MCSlideMediaTypeVideo
                                                  resource:path4
                                              illustration:path3
                                                 thumbnail:path3];

    NSString *path5 = @"http://gemini-voices.b0.upaiyun.com/e064992e99704c60a4130991c0aba2cf.mp3";
    MCSlideMedia *m5 = [[MCSlideMedia alloc] initWithTitle:@"canon"
                                                 mediaType:MCSlideMediaTypeAudio
                                                  resource:path5
                                              illustration:path3
                                                 thumbnail:path1];

    NSArray *medias = @[m1, m2, m5, m3, m4, m4, m2, m2, m2, m2, m4, m4, m4, m5, m1, m1, m2];

    MCSlideViewController *slideViewControllor = [[MCSlideViewController alloc] initWithMediaData:medias remote:true];

    [self.navigationController pushViewController:slideViewControllor animated:YES];

}

@end
