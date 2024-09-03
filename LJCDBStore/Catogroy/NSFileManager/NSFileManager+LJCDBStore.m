//
//  NSFileManager+LJCDBStore.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "NSFileManager+LJCDBStore.h"

@implementation NSFileManager (LJCDBStore)

+ (NSString *)databasePath
{
    NSString *path = [NSString stringWithFormat:@"%@/Database/", [self rootUserPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:@"common.sqlite3"];
}

+ (NSString *)chatImageCachePath
{
    NSString *path = [NSString stringWithFormat:@"%@/Chat/Image", [NSFileManager rootUserPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return path;
}

+ (NSString *)chatVideoCachePath
{
    NSString *path = [NSString stringWithFormat:@"%@/Chat/Video", [NSFileManager rootUserPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return path;
}

#pragma mark -
+ (NSString *)rootUserPath
{
    NSString *vComponent = @"Formal"; ///< 正式
#if LJC_NETWORK_ALPHA
    vComponent = @"Alpha";
#elif LJC_NETWORK_BETA
    vComponent = @"Beta";
#else
    // 正式
#endif
    ///< 涉及登录用户的话，可以在 vComponent 前加一个 userId
    return [NSString stringWithFormat:@"%@/%@", [NSFileManager documentsPath], vComponent];
}


@end
