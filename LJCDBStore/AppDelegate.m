//
//  AppDelegate.m
//  LJCDBStore
//
//  Created by 林锦超 on 19/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "AppDelegate.h"
#import "YTKNetworkConfig.h"
//#import "GYMonitor.h"
#import "FPSDisplay.h"
#import "YYFPSLabel.h"
#import "LJCStoreMonitor.h"

#import "LJCRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Note: Key window & Root vc
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[LJCRootViewController new]];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    
    // config Network
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = LJC_BASE_URL;
    config.debugLogEnabled = YES;
    
    // GYMonitor
//    [self startMonitor];
    [FPSDisplay shareFPSDisplay];
    
    /// FPS
    YYFPSLabel *fpsLabel = [YYFPSLabel new];
    [fpsLabel sizeToFit];
    fpsLabel.top = kNavStatusBarHeight + 10;
    fpsLabel.left = 12;
    [self.window addSubview:fpsLabel];
    
    
    /// DB Monitor
//    [[LJCStoreMonitor sharedMonitor] monitor];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private
//- (void)startMonitor
//{
//    [GYMonitor sharedInstance].monitorFPS = YES;
//    [GYMonitor sharedInstance].showDebugView = YES;
//    [[GYMonitor sharedInstance] startMonitor];
//}
//
//- (void)stopMonitor
//{
//    [GYMonitor sharedInstance].monitorFPS = NO;
//    [GYMonitor sharedInstance].showDebugView = NO;
//    [[GYMonitor sharedInstance] startMonitor];
//}
@end
