//
//  AuthorizationHelper.m
//  telemedicine
//
//  Created by 林锦超 on 25/11/2016.
//  Copyright © 2016 UserDu. All rights reserved.
//

#import "LJCAuthorizationHelper.h"
#import <AVFoundation/AVFoundation.h>
//#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LJCDeviceHelper.h"

typedef NS_ENUM(NSInteger, LJCAuthorizetionType)
{
    LJCAuthorizetionTypeCamera         = 0,
    LJCAuthorizetionTypePhotoLibrary   = 1,
    LJCAuthorizetionTypeMicrophone     = 2,
};

@implementation LJCAuthorizationHelper

#pragma mark - Camera
+ (BOOL)isCameraAuthorized
{
    return [self isCameraAuthorizedWithRequestCompletion:nil];
}

+ (BOOL)isCameraAuthorizedWithRequestCompletion:(LJCAuthorizationHelperRequestCompletionHandler)handler
{
    if (TARGET_IPHONE_SIMULATOR) {
        [self p_alertWithType:LJCAuthorizetionTypeCamera];
        return NO;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [self p_alertWithType:LJCAuthorizetionTypeCamera];
        return NO;
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // 首次
        [self requestCameraAuthorizeWithCompletion:handler];
    }
    return (authStatus == AVAuthorizationStatusAuthorized);
}

+ (void)requestCameraAuthorizeWithCompletion:(LJCAuthorizationHelperRequestCompletionHandler)handler
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler();
                }
            });
        }
    }];
}

#pragma mark - PhotoLibrary
+ (BOOL)isPhotoLibraryAuthorized
{
    return [self isPhotoLibraryAuthorizedWithRequestCompletion:nil];
}

+ (BOOL)isPhotoLibraryAuthorizedWithRequestCompletion:(LJCAuthorizationHelperRequestCompletionHandler)handler
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        [self p_alertWithType:LJCAuthorizetionTypePhotoLibrary];
        return NO;
    }
    else if (status == PHAuthorizationStatusNotDetermined) {
        // 首次
        [self requestPhotoLibraryAuthorizeWithCompletion:handler];
    }
    return (status == PHAuthorizationStatusAuthorized);
}

+ (void)requestPhotoLibraryAuthorizeWithCompletion:(LJCAuthorizationHelperRequestCompletionHandler)handler
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler();
                }
            });
        }
    }];
}

#pragma mark - Microphone
+ (BOOL)isMicrophoneAuthorized
{
    __block BOOL isAuthorized = YES;
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            isAuthorized = granted;
            
            if (!granted) {
                [self p_alertWithType:LJCAuthorizetionTypeMicrophone];
            }
        }];
    }
    return isAuthorized;
}

#pragma mark - Private
+ (void)p_alertWithType:(LJCAuthorizetionType)type
{
    NSString *destination = @"";
    switch (type) {
        case LJCAuthorizetionTypeCamera:
            destination = @"相机";
            break;
        case LJCAuthorizetionTypePhotoLibrary:
            destination = @"相册";
            break;
        case LJCAuthorizetionTypeMicrophone:
            destination = @"麦克风";
            break;
    }
    
    NSString *title = (type == LJCAuthorizetionTypeMicrophone) ? @"无法录音" : nil;
    NSString *appName = [LJCDeviceHelper sharedHelper].appName ?: @"App";
    NSString *message = [NSString stringWithFormat:@"请在iPhone的“程序-设置-%@”选项中，允许%@访问你的%@。", destination, appName, destination];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
#pragma clang diagnostic pop
}

@end
