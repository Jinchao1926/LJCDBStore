//
//  UIImage+LJCVideoThumb.m
//  LJCDBStore
//
//  Created by 林锦超 on 20/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "UIImage+LJCVideoThumb.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (LJCVideoThumb)

+ (UIImage *)screenShotImageFromVideoPath:(NSURL *)fileURL
{
    if (!fileURL || !fileURL.isFileURL) {
        return nil;
    }
    
    UIImage *shotImage = nil;
    NSError *error = nil;
    CMTime actualTime;
    CMTime time = CMTimeMake(0, 20);    //0,20 video.length:166.220703(KB) thumb.length:190.094727(KB)
//    CMTime time = CMTimeMakeWithSeconds(0, 600);
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return shotImage;
}


@end
