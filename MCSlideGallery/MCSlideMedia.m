//
//  MCSlideMedia.m
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MCSlideMedia.h"

@implementation MCSlideMedia

- (id)initWithTitle:(NSString *)title
    mediaType:(MCGalleryMediaType)mediaType
    resource:(NSString *)resource
    illustration:(NSString *)illustration
    thumbnail:(NSString *)thumbnail
{
    if (self = [super init]) {
        self.title = title;
        self.mediaType = mediaType;
        self.resource = resource;
        self.illustration = illustration;
        self.thumbnail = thumbnail;
    }

    return self;
}

@end
