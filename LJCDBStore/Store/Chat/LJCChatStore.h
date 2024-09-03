//
//  LJCChatStore.h
//  LJCDBStore
//
//  Created by 林锦超 on 27/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJCChatModel.h"

@interface LJCChatStore : NSObject


+ (BOOL)clearChatMessages;
+ (NSArray<LJCChatModel *> *)chatMessagesWithRange:(NSRange)range;

/// 返回图片／视频记录
+ (NSArray<LJCChatModel *> *)chatImageReleatedMessage;


//MARK: Insert
+ (BOOL)insertChatMessage:(LJCChatModel *)message;
+ (BOOL)replaceChatMessage:(LJCChatModel *)message;

//MARK: Delete
- (BOOL)removeChatMessageWithChatId:(NSInteger)chatId;
@end
