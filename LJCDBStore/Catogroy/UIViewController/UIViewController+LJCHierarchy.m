//
//  UIViewController+LJCHierarchy.m
//  LJCDBStore
//
//  Created by 林锦超 on 05/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "UIViewController+LJCHierarchy.h"

@implementation UIViewController (LJCHierarchy)

+ (__kindof UIViewController *)ljc_topMostViewController
{
    //    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *appRootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    // tabbar
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)topVC;
        topVC = tabBarVC.selectedViewController;
    }
    
    // navigation
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationVC = (UINavigationController *)topVC;
        topVC = navigationVC.childViewControllers.lastObject;
    }
    
    return topVC;
}

@end
