//
//  LJCChatFTSStore.h
//  LJCDBStore
//
//  Created by 林锦超 on 02/01/2018.
//  Copyright © 2018 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJCChatFTSModel.h"
#import "LJCChatModel.h"

@interface LJCChatFTSStore : NSObject

/// 检索消息记录
+ (NSArray<LJCChatFTSModel *> *)chatMessagesMatch:(NSString *)condition;
+ (BOOL)clearChatFTSMessages;

//MARK: Insert
+ (BOOL)insertChatFTSMessage:(LJCChatFTSModel *)message;
+ (BOOL)insertChatFTSMessageWithOrigin:(LJCChatModel *)message;

@end
