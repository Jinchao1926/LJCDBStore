//
//  LJCChatFTSModel+WCTTableCoding.h
//  LJCDBStore
//
//  Created by 林锦超 on 02/01/2018.
//  Copyright © 2018 林锦超. All rights reserved.
//

#import "LJCChatFTSModel.h"
#import <WCDBObjc/WCDBObjc.h>

@interface LJCChatFTSModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(chatId)
WCDB_PROPERTY(content)

@end
