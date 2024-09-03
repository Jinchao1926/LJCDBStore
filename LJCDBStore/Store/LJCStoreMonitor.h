//
//  LJCStoreMonitor.h
//  LJCDBStore
//
//  Created by 林锦超 on 21/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, LJCStoreMonitorType)
{
    LJCStoreMonitorPerformance  = 1 << 1,   /// 性能监控
    LJCStoreMonitorSQL          = 1 << 2,   /// SQL 语句监控
    LJCStoreMonitorError        = 1 << 3,   /// 错误监控
    LJCStoreMonitorAll          = LJCStoreMonitorPerformance | LJCStoreMonitorSQL | LJCStoreMonitorError,
};

@interface LJCStoreMonitor : NSObject

+ (instancetype)sharedMonitor;

/// 监控
- (void)monitor;
- (void)monitor:(LJCStoreMonitorType)type;
/// 停止监控
- (void)stopMonitor;

//- (void)monitorGlobalPerformance;
//- (void)monitorGlobalSQL;
//- (void)monitorGlobalError;
@end
