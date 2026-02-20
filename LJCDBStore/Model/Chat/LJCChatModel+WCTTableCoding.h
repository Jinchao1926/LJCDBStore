//
//  LJCChatModel+WCTTableCoding.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatModel.h"
#import <WCDBObjc/WCDBObjc.h>

@interface LJCChatModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(chatId)
WCDB_PROPERTY(chatServerId)
WCDB_PROPERTY(fromUserId)
WCDB_PROPERTY(fromUserName)
WCDB_PROPERTY(fromUserAvatarURL)
WCDB_PROPERTY(toUserId)
WCDB_PROPERTY(toUserName)
WCDB_PROPERTY(toUserAvatarURL)
WCDB_PROPERTY(createTime)

WCDB_PROPERTY(chatType)
WCDB_PROPERTY(sendState)
WCDB_PROPERTY(readState)

WCDB_PROPERTY(content)
WCDB_PROPERTY(fileId)
WCDB_PROPERTY(fileName)
WCDB_PROPERTY(fileURL)

WCDB_PROPERTY(thumbFileId)
WCDB_PROPERTY(thumbFileName)
WCDB_PROPERTY(thumbFileURL)

WCDB_PROPERTY(duration)
WCDB_PROPERTY(photoWidth)
WCDB_PROPERTY(photoHeight)
@end
