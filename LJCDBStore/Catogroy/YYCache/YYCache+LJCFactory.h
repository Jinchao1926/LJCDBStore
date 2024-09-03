//
//  YYCache+LJCFactory.h
//  LJCDBStore
//
//  Created by 林锦超 on 06/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <YYKit/YYKit.h>

@interface YYCache (LJCFactory)

///< 聊天图片/视频缓存
+ (YYCache *)chatImageCache;
+ (YYCache *)chatVideoCache;

+ (NSString *)chatVideoCachePath;

+ (void)emptyCaches;

///< 聊天表情缓存
+ (YYMemoryCache *)chatEmoticonCache;
@end
