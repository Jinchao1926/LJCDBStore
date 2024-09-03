//
//  LJCCameraRecorderProxy.h
//  LJCDBStore
//
//  Created by 林锦超 on 18/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LJCCameraRecorderProxyType)
{
    LJCCameraRecorderProxyChat,
};

///< 图片选择完成
typedef void(^LJCCameraRecorderProxyDidFinishPickingPhoto)(UIImage *photo);
///< 视频选择完成
typedef void(^LJCCameraRecorderProxyDidFinishPickingVideo)(NSURL *videoURL, NSTimeInterval duration, UIImage *coverImage);

@interface LJCCameraRecorderProxy : NSObject
///< 代理类型
@property (nonatomic, assign) LJCCameraRecorderProxyType proxyType;
@property (nonatomic, copy) LJCCameraRecorderProxyDidFinishPickingPhoto photoPickHandler;
@property (nonatomic, copy) LJCCameraRecorderProxyDidFinishPickingVideo videoPickHandler;

+ (instancetype)proxyWithType:(LJCCameraRecorderProxyType)type;

- (void)showCamera;
@end
