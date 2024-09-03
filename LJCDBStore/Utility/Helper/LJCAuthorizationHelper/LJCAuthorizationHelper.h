//
//  AuthorizationHelper.h
//  telemedicine
//
//  Created by 林锦超 on 25/11/2016.
//  Copyright © 2016 UserDu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LJCAuthorizationHelperRequestCompletionHandler)(void);
@interface LJCAuthorizationHelper : NSObject

///< 判断是否有打开相机的权限
+ (BOOL)isCameraAuthorized;
+ (BOOL)isCameraAuthorizedWithRequestCompletion:(LJCAuthorizationHelperRequestCompletionHandler)handler;
+ (void)requestCameraAuthorizeWithCompletion:(LJCAuthorizationHelperRequestCompletionHandler)handler;

///< 判断是否有打开相册的权限
+ (BOOL)isPhotoLibraryAuthorized;
+ (BOOL)isPhotoLibraryAuthorizedWithRequestCompletion:(LJCAuthorizationHelperRequestCompletionHandler)handler;
+ (void)requestPhotoLibraryAuthorizeWithCompletion:(LJCAuthorizationHelperRequestCompletionHandler)handler;

///< 判断是否有打开麦克风的权限
+ (BOOL)isMicrophoneAuthorized;
@end
