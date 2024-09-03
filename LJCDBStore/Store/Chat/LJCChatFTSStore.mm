//
//  LJCChatFTSStore.m
//  LJCDBStore
//
//  Created by 林锦超 on 02/01/2018.
//  Copyright © 2018 林锦超. All rights reserved.
//

#import "LJCChatFTSStore.h"
#import "LJCStoreManager.h"
#import "LJCChatFTSModel.h"
#import "LJCChatFTSModel+WCTTableCoding.h"

static NSString *const kTableChatFTS = @"ChatFTS";

@implementation LJCChatFTSStore

+ (void)initialize
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    
    /// FTS表
    [database setTokenizer:WCTTokenizerNameWCDB];
    BOOL create = [database createVirtualTableOfName:kTableChatFTS withClass:LJCChatFTSModel.class];
    NSLog(@"createFTS");
}

+ (NSArray<LJCChatFTSModel *> *)chatMessagesMatch:(NSString *)condition
{
    if (condition.length == 0) {
        return @[];
    }
    
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        NSString *match = [condition stringByAppendingString:@"*"];
        // 获取部分字段即可
        return [database getObjectsOnResults:{ LJCChatFTSModel.content } fromTable:kTableChatFTS where:LJCChatFTSModel.content.match(match) orderBy:LJCChatFTSModel.chatId.order(WCTOrderedAscending)];
        //        return [database getObjectsOfClass:LJCChatModel.class fromTable:kTableChat where:LJCChatModel.content.match(match) orderBy:LJCChatModel.chatId.order(WCTOrderedAscending)];
    }
    return @[];
}

+ (BOOL)clearChatFTSMessages
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database deleteAllObjectsFromTable:kTableChatFTS];
    }
    return NO;
}

//MARK: Insert
+ (BOOL)insertChatFTSMessage:(LJCChatFTSModel *)message
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database insertObject:message into:kTableChatFTS];
    }
    return NO;
}

+ (BOOL)insertChatFTSMessageWithOrigin:(LJCChatModel *)message
{
    LJCChatFTSModel *fts = [LJCChatFTSModel ftsModelWithOrigin:message];
    return [self insertChatFTSMessage:fts];
}

@end
