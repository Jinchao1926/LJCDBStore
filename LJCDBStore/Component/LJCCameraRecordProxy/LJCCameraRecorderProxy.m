//
//  LJCCameraRecorderProxy.m
//  LJCDBStore
//
//  Created by 林锦超 on 18/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCCameraRecorderProxy.h"
#import "LJCCameraRecorderController.h"
#import "LJCAuthorizationHelper.h"

@interface LJCCameraRecorderProxy()<LJCCameraRecorderDelegate>
@end
@implementation LJCCameraRecorderProxy

+ (instancetype)proxyWithType:(LJCCameraRecorderProxyType)type
{
    LJCCameraRecorderProxy *proxy = [[self class] new];
    proxy.proxyType = type;
    return proxy;
}

- (instancetype)init
{
    if (self = [super init]) {
        _proxyType = NSNotFound;
    }
    return self;
}

- (void)showCamera
{
    @weakify(self)
    BOOL canShowCamera = [LJCAuthorizationHelper isCameraAuthorizedWithRequestCompletion:^{
        @strongify(self)
        [self p_pushCameraRecordController];
    }];
    
    if (canShowCamera) {
        [self p_pushCameraRecordController];
    }
}

#pragma mark -
- (void)p_pushCameraRecordController
{
    LJCCameraRecorderController *cameraRecordVC = [LJCCameraRecorderController new];
    cameraRecordVC.delegate = self;
    [[UIViewController ljc_topMostViewController] presentViewController:cameraRecordVC animated:YES completion:nil];
}

#pragma mark - LJCCameraRecorderDelegate
- (void)LJCCameraRecorderControllerDidFinishTakingPhoto:(UIImage *)image
{
    if (self.photoPickHandler) {
        self.photoPickHandler(image);
    }
}

- (void)LJCCameraRecorderControllerDidFinishRecordingVideo:(NSURL *)videoURL duration:(NSTimeInterval)duration thumbnail:(UIImage *)thumbnail
{
    if (self.videoPickHandler) {
        self.videoPickHandler(videoURL, duration, thumbnail);
    }
}

@end
