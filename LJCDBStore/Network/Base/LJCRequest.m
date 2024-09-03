//
//  LJCRequest.m
//  LJCDBStore
//
//  Created by 林锦超 on 30/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCRequest.h"
#import "LJCDeviceHelper.h"

@implementation LJCRequest

#pragma mark - Extension
- (void)startWithCompletionBlock:(LJCRequestCompletionBlock)handler
{
    if (self.isShowRequestHUD) {
        [SVProgressHUD show];
    }
    
    [self startWithCompletionBlockWithSuccess:^(__kindof LJCRequest * _Nonnull request) {
        // HUD & Logs
        if (self.isShowRequestHUD) {
            [SVProgressHUD dismiss];
        }
        [self LJCSuccessLog];
        
        // Note: 如果需要做token验证超时，可以在这里添加
        
        //
        if (handler) {
            handler(request);
        }
        
    } failure:^(__kindof LJCRequest * _Nonnull request) {
        // HUD & Logs
        if (self.isShowRequestHUD) {
            [SVProgressHUD dismiss];
        }
        [self LJCErrorLog];
        
        //
        if (handler) {
            handler(request);
        }
    }];
}

- (void)LJCSuccessLog
{
    NSLog(@"request[%@] :%@", self.requestUrl, self.responseJSONObject);
}

- (void)LJCErrorLog
{
    NSLog(@"request[%@] error:%@", self.requestUrl, self.error.localizedDescription);
}

#pragma mark - Settings
// 参数如果有一些特殊字符（如中文或空格），也会被自动编码。
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

// 指定入参格式
- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeJSON;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 30;
}

// 请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    LJCDeviceHelper *deviceHelper = [LJCDeviceHelper sharedHelper];
    return @{ @"tn" : @"",
              @"DeviceId" : deviceHelper.uuid ?: @"",
              @"PhoneType" : @"3",  //3-iphone 4-ipad
              @"SystemVersion" : deviceHelper.totalSystemVersion ?: @"",
              @"AppVersion" : deviceHelper.appVersion ?: @"",
              @"ScreenSize" : deviceHelper.deviceScreenSize ?: @"",
              @"CameraPixels" : deviceHelper.deviceCameraPixels ?: @"",
              @"DeviceType" : deviceHelper.deviceVersion ?: @"",
              @"DevicePush" : @"1", //支持的推送 1：极光，2：小米，3：华为
              @"UserPlatform" : @"0"    //用户平台类型，0：患者端，1：医生端
              };
}

#pragma mark - Getter
- (BOOL)isResponseJSONSuccess
{
    if (!self.responseJSONObject) {
        return NO;
    }
    return self.responseJSONObject[@"success"];
}

- (NSString *)responseJSONEntity
{
    if (!self.responseJSONObject) {
        return nil;
    }
    return self.responseJSONObject[@"entity"];
}

- (NSString *)responseJSONMessage
{
    if (!self.responseJSONObject) {
        return nil;
    }
    return self.responseJSONObject[@"message"];
}

- (NSString *)responseJSONErrorCode
{
    if (!self.responseJSONObject) {
        return nil;
    }
    return self.responseJSONObject[@"errorCode"];
}


@end
