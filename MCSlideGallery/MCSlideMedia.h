//
//  MCSlideMedia.h
//  MCSlideGallery Demo
//
//  Created by Lanvige Jiang on 5/7/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MCGalleryMediaTypePhoto,
    MCGalleryMediaTypeAudio,
    MCGalleryMediaTypeVideo
} MCGalleryMediaType;

@interface MCSlideMedia : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) MCGalleryMediaType mediaType;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSString *illustration;
@property (nonatomic, strong) NSString *thumbnail;

- (id)initWithTitle:(NSString *)title
    mediaType:(MCGalleryMediaType)mediaType
    resource:(NSString *)resource
    illustration:(NSString *)illustration
    thumbnail:(NSString *)thumbnail;

@end
