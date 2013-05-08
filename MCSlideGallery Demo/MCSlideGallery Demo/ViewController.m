//
//  ViewController.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "ViewController.h"
#import "MCSlideMedia.h"
#import "MCSlideViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openButtonAction:(id)sender
{
    MCSlideMedia *m1 = [[MCSlideMedia alloc] initWithTitle:@"hawaii"
                                                 mediaType:MCSlideMediaTypePhoto
                                                  resource:@"hawaii.jpg"
                                              illustration:@"Hawaii"
                                                 thumbnail:@"hawaii.jpg"];
    
    MCSlideMedia *m2 = [[MCSlideMedia alloc] initWithTitle:@"sushi"
                                                 mediaType:MCSlideMediaTypePhoto
                                                  resource:@"sushi.jpg"
                                              illustration:@"sushi"
                                                 thumbnail:@"sushi.jpg"];
    
    MCSlideMedia *m3 = [[MCSlideMedia alloc] initWithTitle:@"lava"
                                                 mediaType:MCSlideMediaTypePhoto
                                                  resource:@"lava.jpg"
                                              illustration:@"lava"
                                                 thumbnail:@"lava.jpg"];
    
    NSArray *medias = @[m1, m2, m3];
    
    MCSlideViewController *control = [[MCSlideViewController alloc] initWithMediaData:medias];
    
    [self.navigationController pushViewController:control animated:YES];
}

@end
