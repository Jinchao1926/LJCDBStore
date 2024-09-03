//
//  LJCPhotoBrowserProxy.m
//  LJCDBStore
//
//  Created by 林锦超 on 11/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCPhotoBrowserProxy.h"

@interface LJCPhotoBrowserProxy()<UINavigationControllerDelegate>
@property (nonatomic, weak) UIViewController *topMostVC;
@end
@implementation LJCPhotoBrowserProxy

- (instancetype)init
{
    if (self = [super init]) {
        _photos = [NSMutableArray array];
        _proxyType = NSNotFound;
    }
    return self;
}

#pragma mark - Public
- (void)presentPhotoBrowser
{
    [self presentPhotoBrowserWithIndex:0];
}

- (void)presentPhotoBrowserWithIndex:(NSUInteger)index
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:self.photos];
    browser.delegate = self;
    browser.displayActionButton = YES;       // 显示分享按钮
    browser.displayNavArrows = YES;          // 显示箭头切换控件
//    browser.displayNavRotates = YES;        // 显示旋转控件
    browser.displaySelectionButtons = NO;   // 显示选中按钮
    browser.zoomPhotosToFill = NO;
    browser.alwaysShowControls = YES;       // 控件是否固定显示
    browser.enableGrid = YES;               // 显示网格缩略图
    browser.startOnGrid = NO;               // 开始就显示网格
    [browser setCurrentPhotoIndex:index];
    
    // Note: Nav处理，需要改变nav风格
    // 主要是标题的 "1 of 3"
    // MWPhotoBrowser内部没有针对setTitleTextAttributes做处理
    // 需要自己保存
    _topMostVC = [UIViewController ljc_topMostViewController];
    UINavigationController *topMostNavC = _topMostVC.navigationController;
    topMostNavC.delegate = self;
//    self.previousNavBarTitleTextAttributes = presentedNavC.navigationBar.titleTextAttributes;
    
//    [presentedNavC setDelegate:self];
//    [presentedNavC.navigationBar setBarTintColor:[UIColor colorGrayNav]];
//    [presentedNavC.navigationBar setTintColor:[UIColor colorPurpleDefault]];
//    [presentedNavC.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontNavTitle]}];
    [topMostNavC pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count) {
        return self.photos[index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count) {
        return self.photos[index];
    }
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isEqual:_topMostVC]) {
        navigationController.delegate = nil;
        
        if (self.dismissHandler) {
            self.dismissHandler();
        }
    }
}
@end
