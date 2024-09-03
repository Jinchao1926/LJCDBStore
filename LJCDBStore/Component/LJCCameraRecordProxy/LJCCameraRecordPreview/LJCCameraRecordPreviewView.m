//
//  LJCCameraRecordPreviewView.m
//  LJCDBStore
//
//  Created by 林锦超 on 19/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCCameraRecordPreviewView.h"
#import "LJCCameraRecordPreviewToolbar.h"
#import "UIImage+LJCOrietation.h"
#import "SCRecordSession+LJCExtension.h"

@interface LJCCameraRecordPreviewView()<SCAssetExportSessionDelegate>
@property (nonatomic, strong) SCPlayer *player;
@property (nonatomic, strong) SCAssetExportSession *exportSession;
@property (nonatomic, strong) SCVideoPlayerView *playerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LJCCameraRecordPreviewToolbar *toolbar;
@end
@implementation LJCCameraRecordPreviewView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [_player pause];
}

#pragma mark - Setter
- (void)setRecordSession:(SCRecordSession *)recordSession
{
    if ([_recordSession isEqual:recordSession]) {
        return;
    }
    _recordSession = recordSession;
    
    [self addSubview:self.playerView];
    [self addSubview:self.toolbar];
    
    [self.player setItemByAsset:recordSession.assetRepresentingSegments];
    [self.player play];
}

- (void)setPhoto:(UIImage *)photo
{
    if ([_photo isEqual:photo]) {
        return;
    }
    _photo = photo;
    
    self.imageView.image = photo;
    [self addSubview:self.imageView];
    [self addSubview:self.toolbar];
}

#pragma mark - Getter
- (SCPlayer *)player
{
    if (!_player) {
        _player = [SCPlayer player];
        _player.loopEnabled = NO;  //循环播放
    }
    return _player;
}

- (SCVideoPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [[SCVideoPlayerView alloc] initWithPlayer:self.player];
        _playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _playerView.frame = self.bounds;
    }
    return _playerView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

- (LJCCameraRecordPreviewToolbar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[LJCCameraRecordPreviewToolbar alloc] initWithFrame:CGRectMake(0, self.height - 200 - kUnsafeBottomHeight, self.width, 200)];
        
        @weakify(self)
        _toolbar.retakedHandler = ^{
            @strongify(self)
            // remove xxx-SCVideo.0.mov, .1.mov, ...
            [self.recordSession cancelSessionTotally:nil];
            [self removeFromSuperview];
        };
        _toolbar.doneHandler = ^{
            @strongify(self)
            if (self.photo && self.imageHandler) {
                UIImage *imageFixed = [self.photo imageOrientationUp];  //修正图片方向
                self.imageHandler(imageFixed);
            }
            else if (self.recordSession && self.videoHandler) {
                [self p_exportVideo];
            }
        };
    }
    return _toolbar;
}

#pragma mark -
- (void)p_exportVideo
{
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:self.recordSession.assetRepresentingSegments];
//    exportSession.videoConfiguration.filter = currentFilter;
    exportSession.videoConfiguration.preset = SCPresetLowQuality;
    exportSession.audioConfiguration.preset = SCPresetLowQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    exportSession.outputUrl = self.recordSession.outputUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
//    exportSession.contextType = SCContextTypeAuto;
    self.exportSession = exportSession;
    
    [SVProgressHUD show];
    NSLog(@"Starting exporting");
    
    @weakify(self)
    CFTimeInterval time = CACurrentMediaTime();
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        @strongify(self)
        
        if (self.exportSession.cancelled) {
            NSLog(@"Export was cancelled");
        }
        else {
            NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
        
        NSURL *videoURL = nil;
        NSTimeInterval duration = 0.f;
        UIImage *thumbnail = nil;
        
        if (!self.exportSession.error) {
            videoURL = self.exportSession.outputUrl;
            duration = CMTimeGetSeconds(self.recordSession.assetRepresentingSegments.duration);
            thumbnail = self.recordSession.thumbnail;
            NSLog(@"videoURL:%@ duration:%lf thumbnail:%@", videoURL, duration, thumbnail);
            
            // once export xxx-SCVideo-merged.mov
            // remove xxx-SCVideo.0.mov, .1.mov, ...
            [self.recordSession cancelSessionTotally:nil];
        }
        
        // success or not.
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (videoURL) {
                NSLog(@"thumbnail:%@", thumbnail);
                self.videoHandler(videoURL, duration, thumbnail);
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"导出失败"];
                [self removeFromSuperview];
            }
        });
    }];
}

#pragma mark - SCAssetExportSessionDelegate
- (void)assetExportSessionDidProgress:(SCAssetExportSession *)assetExportSession
{
    [SVProgressHUD showProgress:assetExportSession.progress];
}

@end
