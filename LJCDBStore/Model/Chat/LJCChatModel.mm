//
//  LJCChatModel.mm
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatModel+WCTTableCoding.h"
#import "LJCChatModel.h"
#import <WCDBObjc/WCDBObjc.h>

@implementation LJCChatModel

// https://github.com/Tencent/wcdb/issues/1420
@synthesize lastInsertedRowID;

WCDB_IMPLEMENTATION(LJCChatModel)
WCDB_SYNTHESIZE(chatId)
WCDB_SYNTHESIZE(chatServerId)
WCDB_SYNTHESIZE(fromUserId)
WCDB_SYNTHESIZE(fromUserName)
WCDB_SYNTHESIZE(fromUserAvatarURL)
WCDB_SYNTHESIZE(toUserId)
WCDB_SYNTHESIZE(toUserName)
WCDB_SYNTHESIZE(toUserAvatarURL)
WCDB_SYNTHESIZE(createTime)

WCDB_SYNTHESIZE(chatType)
WCDB_SYNTHESIZE(sendState)
WCDB_SYNTHESIZE(readState)

WCDB_SYNTHESIZE(content)
WCDB_SYNTHESIZE(fileId)
WCDB_SYNTHESIZE(fileName)
WCDB_SYNTHESIZE(fileURL)

WCDB_SYNTHESIZE(thumbFileId)
WCDB_SYNTHESIZE(thumbFileName)
WCDB_SYNTHESIZE(thumbFileURL)

WCDB_SYNTHESIZE(duration)
WCDB_SYNTHESIZE(photoWidth)
WCDB_SYNTHESIZE(photoHeight)

/// 主键自增
WCDB_PRIMARY_AUTO_INCREMENT(chatId)   //主键自增，AUTOINCREMENT is only allowed on an INTEGER PRIMARY KEY

/// Index Name = Table Name + Index Subfix Name
WCDB_INDEX("_indexChatId", chatId)


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
