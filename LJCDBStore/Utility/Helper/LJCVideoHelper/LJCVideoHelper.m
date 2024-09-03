//
//  LJCVideoHelper.m
//  LJCDBStore
//
//  Created by 林锦超 on 08/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCVideoHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation LJCVideoHelper

+ (NSString *)durationWithVideoTimeInterval:(NSTimeInterval)duration
{
    duration = ceil(duration);
    int minute = 0;
    int second = 0;
    if (duration >= 60.f) {
        minute = duration / 60;
        second = fmod(duration, 60);
    }
    else {
        second = duration;
    }
    return [NSString stringWithFormat:@"%d:%02d", minute, second];
}

+ (NSString *)durationWithVideoURL:(NSURL *)videoURL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts]; // 初始化视频媒体文件
    double duration = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    
    return [self durationWithVideoTimeInterval:duration];
}

+ (NSString *)durationWithAudioURL:(NSURL *)audioURL
{
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    double duration = ceil(player.duration);
    
    int minute = 0;
    int second = 0;
    if (duration >= 60.f) {
        minute = duration / 60;
        second = fmod(duration, 60);
        return [NSString stringWithFormat:@"%d'%d\"", minute, second];
    }
    else {
        second = duration;
        return [NSString stringWithFormat:@"%d\"", second];
    }
}
@end
