//
//  LJCChatStore.m
//  LJCDBStore
//
//  Created by 林锦超 on 27/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatStore.h"
#import "LJCStoreManager.h"
#import "LJCChatModel+WCTTableCoding.h"

static NSString *const kTableChat = @"Chat";

@implementation LJCChatStore

+ (void)initialize
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    BOOL create = [database createTableAndIndexesOfName:kTableChat withClass:LJCChatModel.class];
    NSLog(@"create");
}

+ (BOOL)clearChatMessages
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database deleteAllObjectsFromTable:kTableChat];
    }
    return NO;
}

//MARK: Search
+ (NSArray<LJCChatModel *> *)chatMessagesWithRange:(NSRange)range
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database getObjectsOfClass:LJCChatModel.class fromTable:kTableChat orderBy:LJCChatModel.chatId.order(WCTOrderedDescending) limit:range.length offset:range.location];
//        return [database getObjectsOfClass:LJCChatModel.class fromTable:kTableChat limit:range.length offset:range.location];
    }
    return @[];
}

+ (NSArray<LJCChatModel *> *)chatImageReleatedMessage
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        // LJCChatSourceTypePhoto or LJCChatSourceTypeVideo
        return [database getObjectsOfClass:LJCChatModel.class fromTable:kTableChat where:LJCChatModel.chatType.in(@[ @1, @3 ]) orderBy:LJCChatModel.chatId.order(WCTOrderedAscending)];
    }
    return @[];
}

//MARK: Insert
+ (BOOL)insertChatMessage:(LJCChatModel *)message
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        if ([database insertObject:message into:kTableChat]) {
            message.chatId = message.lastInsertedRowID; //主键
            return YES;
        }
    }
    return NO;
}

+ (BOOL)replaceChatMessage:(LJCChatModel *)message
{
//    NSLog(@"message.chatId:%zd", message.chatId);
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database updateRowsInTable:kTableChat
                              onProperties:LJCChatModel.AllProperties
                                withObject:message
                                     where:LJCChatModel.chatId == message.chatId];
    }
    return NO;
}

- (BOOL)removeChatMessageWithChatId:(NSInteger)chatId
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        [database deleteObjectsFromTable:kTableChat where:LJCChatModel.chatId == chatId];
    }
    return NO;
}
@end
