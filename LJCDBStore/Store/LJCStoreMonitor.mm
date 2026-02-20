//
//  LJCStoreMonitor.m
//  LJCDBStore
//
//  Created by 林锦超 on 21/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCStoreMonitor.h"
#import <WCDBObjc/WCDBObjc.h>

@implementation LJCStoreMonitor

+ (instancetype)sharedMonitor
{
    static LJCStoreMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[self class] new];
    });
    return monitor;
}

- (void)monitor
{
    [self monitor:LJCStoreMonitorAll];
}

- (void)monitor:(LJCStoreMonitorType)type
{
    if (type & LJCStoreMonitorPerformance) {
        [self monitorGlobalPerformance];
    }
    if (type & LJCStoreMonitorSQL) {
        [self monitorGlobalSQL];
    }
    if (type & LJCStoreMonitorError) {
        [self monitorGlobalError];
    }
}

- (void)stopMonitor
{
    [WCTDatabase globalTracePerformance:nil];
    [WCTDatabase globalTraceError:nil];
    [WCTDatabase globalTraceSQL:nil];
}

#pragma mark - Monitor
- (void)monitorGlobalPerformance
{
    // trace
    // You should register trace before all db operation.
    [WCTDatabase globalTracePerformance:^(WCTTag tag, NSString *path, uint64_t handleId, NSString *sql, WCTPerformanceInfo *info) {
        NSLog(@"[DBPerformanceMonitor] [%llu] at path %@ takes %lld nanoseconds to execute sql %@",
                  handleId, path, info.costInNanoseconds, sql);
    }];
}

- (void)monitorGlobalSQL
{
    // SQL
    [WCTDatabase globalTraceSQL:^(WCTTag tag, NSString *path, uint64_t handleId, NSString *sql, NSString *info) {
        NSLog(@"[DBSQLMonitor] [%llu] at path %@ executed SQL %@", handleId, path, sql);
    }];
}

- (void)monitorGlobalError
{
    // error
    [WCTDatabase globalTraceError:^(WCTError *error) {
        assert(error.level != WCTErrorLevelFatal);
        NSLog(@"[DBErrorMonitor] %@", error);;
    }];
}

@end
