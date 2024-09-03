//
//  NSFileManager+LJCDBStore.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (LJCDBStore)

///< DB目录
+ (NSString *)databasePath;

///< 聊天缓存目录
+ (NSString *)chatImageCachePath;
+ (NSString *)chatVideoCachePath;
@end
