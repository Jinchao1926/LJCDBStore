//
//  LJCImagePickerProxy.m
//  LJCDBStore
//
//  Created by 林锦超 on 05/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCPhotoPickerProxy.h"
#import "LJCAuthorizationHelper.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"

#define kLJCPhotoPickerMaxPhotosPerRow  4
#define kLJCPhotoPickerMaxPhotosTotal   10

@interface LJCPhotoPickerProxy()<TZImagePickerControllerDelegate>
@end

@implementation LJCPhotoPickerProxy

- (void)dealloc
{
    NSLog(@"dealloc LJCPhotoPickerProxy");
}

+ (instancetype)proxyWithType:(LJCPhotoPickerProxyType)type
{
    LJCPhotoPickerProxy *proxy = [[self class] new];
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

#pragma mark - Public
- (void)showPhotoLibrary
{
    @weakify(self)
    BOOL canShowPhoto = [LJCAuthorizationHelper isPhotoLibraryAuthorizedWithRequestCompletion:^{
        @strongify(self)
        [self p_pushImagePickerController];
    }];
    
    if (canShowPhoto) {
        [self p_pushImagePickerController];
    }
}

- (void)showCamera
{
    
}

#pragma mark -
- (void)p_pushImagePickerController
{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:kLJCPhotoPickerMaxPhotosTotal columnNumber:kLJCPhotoPickerMaxPhotosPerRow delegate:self pushPhotoPickerVc:YES];
    imagePicker.photoWidth = 200;   //导出图片宽度200像素
    imagePicker.sortAscendingByModificationDate = NO;
//    imagePicker.allowPreview = NO;
    [[UIViewController ljc_topMostViewController] presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
     NSLog(@"cancel");
}

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    if (!isSelectOriginalPhoto) {
        ///< 小图
        if (photos.count > 0) {
            if (self.photoPickHandler) {
                self.photoPickHandler(photos);
            }
        }
    }
    else {
        ///< 原图
        NSInteger count = assets.count;
        __block NSMutableArray *originalPhotos = [NSMutableArray array];
        
        [assets enumerateObjectsUsingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info) {
                NSLog(@"photo:%@ info:%@", photo, info);
                [originalPhotos addObject:photo];
                
                if (idx == count - 1) {
                    if (originalPhotos.count > 0) {
                        if (self.photoPickHandler) {
                            self.photoPickHandler(originalPhotos);
                        }
                    }
                }
            }];
        }];
    }
}

// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset
{
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
//        NSTimeInterval duration = phAsset.duration;
//        NSLog(@"pha duration:%lf", duration);
        
        PHVideoRequestOptions *options = [PHVideoRequestOptions new];
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
        options.networkAccessAllowed = NO;
        [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable avasset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            if ([avasset isKindOfClass:[AVURLAsset class]]) {
                AVURLAsset *urlAsset = (AVURLAsset *)avasset;
//                NSLog(@"urlAsset.URL:%@", urlAsset.URL);
                
                if (self.videoPickHandler) {
                    self.videoPickHandler(urlAsset.URL, phAsset.duration, coverImage);
                }
            };
        }];
    }
}

// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset
{
}

@end
