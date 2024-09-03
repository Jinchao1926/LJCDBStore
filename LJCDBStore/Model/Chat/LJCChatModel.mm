//
//  LJCChatModel.mm
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatModel+WCTTableCoding.h"
#import "LJCChatModel.h"
#import <WCDB/WCDB.h>

@implementation LJCChatModel

WCDB_IMPLEMENTATION(LJCChatModel)
WCDB_SYNTHESIZE(LJCChatModel, chatId)
WCDB_SYNTHESIZE(LJCChatModel, chatServerId)
WCDB_SYNTHESIZE(LJCChatModel, fromUserId)
WCDB_SYNTHESIZE(LJCChatModel, fromUserName)
WCDB_SYNTHESIZE(LJCChatModel, fromUserAvatarURL)
WCDB_SYNTHESIZE(LJCChatModel, toUserId)
WCDB_SYNTHESIZE(LJCChatModel, toUserName)
WCDB_SYNTHESIZE(LJCChatModel, toUserAvatarURL)
WCDB_SYNTHESIZE(LJCChatModel, createTime)

WCDB_SYNTHESIZE(LJCChatModel, chatType)
WCDB_SYNTHESIZE(LJCChatModel, sendState)
WCDB_SYNTHESIZE(LJCChatModel, readState)

WCDB_SYNTHESIZE(LJCChatModel, content)
WCDB_SYNTHESIZE(LJCChatModel, fileId)
WCDB_SYNTHESIZE(LJCChatModel, fileName)
WCDB_SYNTHESIZE(LJCChatModel, fileURL)

WCDB_SYNTHESIZE(LJCChatModel, thumbFileId)
WCDB_SYNTHESIZE(LJCChatModel, thumbFileName)
WCDB_SYNTHESIZE(LJCChatModel, thumbFileURL)

WCDB_SYNTHESIZE(LJCChatModel, duration)
WCDB_SYNTHESIZE(LJCChatModel, photoWidth)
WCDB_SYNTHESIZE(LJCChatModel, photoHeight)

/// 主键自增
WCDB_PRIMARY_AUTO_INCREMENT(LJCChatModel, chatId)   //主键自增，AUTOINCREMENT is only allowed on an INTEGER PRIMARY KEY

/// Index Name = Table Name + Index Subfix Name
WCDB_INDEX(LJCChatModel, "_indexChatId", chatId)


- (NSString *)description
{
    return [NSString stringWithFormat:@"< %@:%p chatId:%zd content:%@ fileURL:%@ time:%@ >", [self class], self, self.chatId, self.content, self.fileURL, self.createTime];
}

#pragma mark - Setter
- (void)setFromUserId:(NSString *)fromUserId
{
    _fromUserId = fromUserId;
    
    self.isFromSelf = [fromUserId isEqualToString:LJCChatFromUserId];
}
@end
