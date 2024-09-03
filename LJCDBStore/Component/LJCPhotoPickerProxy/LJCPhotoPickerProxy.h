//
//  LJCImagePickerProxy.h
//  LJCDBStore
//
//  Created by 林锦超 on 05/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LJCPhotoPickerProxyType)
{
    LJCPhotoPickerProxyChat,
    LJCPhotoPickerProxyMe,
};

///< 图片选择完成
typedef void(^LJCPhotoPickerProxyDidFinishPickingPhotos)(NSArray<UIImage *> *photos);
///< 视频选择完成
typedef void(^LJCPhotoPickerProxyDidFinishPickingVideo)(NSURL *videoURL, NSTimeInterval duration, UIImage *coverImage);

@interface LJCPhotoPickerProxy : NSObject
///< 代理类型
@property (nonatomic, assign) LJCPhotoPickerProxyType proxyType;
@property (nonatomic, copy) LJCPhotoPickerProxyDidFinishPickingPhotos photoPickHandler;
@property (nonatomic, copy) LJCPhotoPickerProxyDidFinishPickingVideo videoPickHandler;

+ (instancetype)proxyWithType:(LJCPhotoPickerProxyType)type;

- (void)showPhotoLibrary;
//- (void)showCamera;
@end
