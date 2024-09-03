//
//  LJCStoreMonitor.m
//  LJCDBStore
//
//  Created by 林锦超 on 21/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCStoreMonitor.h"
#import <WCDB/WCDB.h>

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
    [WCTStatistics SetGlobalPerformanceTrace:nil];
    [WCTStatistics SetGlobalErrorReport:nil];
    [WCTStatistics SetGlobalSQLTrace:nil];
}

#pragma mark - Monitor
- (void)monitorGlobalPerformance
{
    //trace
    //You should register trace before all db operation.
    [WCTStatistics SetGlobalPerformanceTrace:^(WCTTag tag, NSDictionary<NSString *, NSNumber *> *sqls, NSInteger cost) {
//        NSLog(@"[DBPerformanceMonitor]-Tag: %d", tag);
        [sqls enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull sql, NSNumber * _Nonnull count, BOOL * _Nonnull stop) {
            NSLog(@"[DBPerformanceMonitor]-SQL: %@ Count: %d", sql, count.intValue);
        }];
        NSLog(@"[DBPerformanceMonitor]-Total cost %ld microseconds", (long) cost / 1000);
    }];
}

- (void)monitorGlobalSQL
{
    //SQL
    [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
        NSLog(@"[DBSQLMonitor] SQL: %@", sql);
    }];
}

- (void)monitorGlobalError
{
    //error
    [WCTStatistics SetGlobalErrorReport:^(WCTError *error) {
        NSLog(@"[DBErrorMonitor] %@", error);
    }];
}

@end
