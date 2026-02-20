//
//  LJCChatFTSModel.mm
//  LJCDBStore
//
//  Created by 林锦超 on 02/01/2018.
//  Copyright © 2018 林锦超. All rights reserved.
//

#import "LJCChatFTSModel+WCTTableCoding.h"
#import "LJCChatFTSModel.h"
#import "LJCChatModel.h"
#import <WCDBObjc/WCDBObjc.h>

@implementation LJCChatFTSModel

WCDB_IMPLEMENTATION(LJCChatFTSModel)
WCDB_SYNTHESIZE(chatId)
WCDB_SYNTHESIZE(content)


/// FTS
/*
 ORM的限制
 
 SQLite的FTS是使用虚拟表实现的，因此其与虚拟表有同样的限制
 
 不支持创建触发器
 不支持、也不需要创建索引
 不支持通过ALTER TABLE为虚拟表添加新的字段
 */
WCDB_VIRTUAL_TABLE_MODULE(WCTModuleFTS3)
WCDB_VIRTUAL_TABLE_TOKENIZE(WCTTokenizerLegacyOneOrBinary)


+ (LJCChatFTSModel *)ftsModelWithOrigin:(LJCChatModel *)origin
{
    LJCChatFTSModel *fts = [LJCChatFTSModel new];
    fts.chatId = origin.chatId;
    fts.content = origin.content;
    return fts;
}
@end
