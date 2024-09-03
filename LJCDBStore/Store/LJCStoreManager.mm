//
//  LJCStoreManager.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCStoreManager.h"
#import "NSFileManager+LJCDBStore.h"

static NSString *const kStoreCipher = @"LJCDBStore";

@implementation LJCStoreManager

- (void)dealloc
{
    [_database close];
}

+ (instancetype)sharedManager
{
    static LJCStoreManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _database = [[WCTDatabase alloc] initWithPath:[NSFileManager databasePath]];
        [_database setCipherKey:[kStoreCipher dataUsingEncoding:NSUTF8StringEncoding]]; //加密
        
        /*
        // 清除数据库文件
        [_database close:^{
            [_database removeFilesWithError:nil];
        }];
         */
    }
    return self;
}
@end
