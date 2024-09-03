//
//  YYCache+LJCFactory.m
//  LJCDBStore
//
//  Created by 林锦超 on 06/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "YYCache+LJCFactory.h"
#import "NSFileManager+LJCDBStore.h"

@implementation YYCache (YMZChat)

#pragma mark -
+ (YYCache *)chatImageCache
{
    static YYCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[YYCache alloc] initWithPath:[NSFileManager chatImageCachePath]];
    });
    return cache;
}

+ (YYCache *)chatVideoCache
{
    static YYCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[YYCache alloc] initWithPath:[NSFileManager chatVideoCachePath]];
        
        cache.diskCache.customArchiveBlock = ^NSData * _Nonnull(id  _Nonnull object) {
            return object;
        };
        cache.diskCache.customUnarchiveBlock = ^id _Nonnull(NSData * _Nonnull data) {
            return data;
        };
        cache.diskCache.customFileNameBlock = ^NSString * _Nonnull(NSString * _Nonnull key) {
            return [NSString stringWithFormat:@"%@.mp4", key.md5String];
        };
    });
    return cache;
}

+ (NSString *)chatVideoCachePath
{
    return [[self chatVideoCache].diskCache.path stringByAppendingPathComponent:@"data"];   //'data' same as YYKVStorage
}

+ (YYMemoryCache *)chatEmoticonCache
{
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"LJCChatEmoticonCache";
    });
    return cache;
}

+ (void)emptyCaches
{
    [[self chatImageCache] removeAllObjects];
    [[self chatVideoCache] removeAllObjects];
}
@end
