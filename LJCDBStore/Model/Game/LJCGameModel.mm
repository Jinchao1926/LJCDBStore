//
//  LJCGameModel.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCGameModel.h"
#import "LJCGameModel+WCTTableCoding.h"

// 增加字段：对于需要增加的字段，只需在定义处添加，并再次执行createTableAndIndexesOfName:withClass:即可。
// 删除字段：对于需要删除字段，只需将其定义删除即可。
// 由于SQLite不支持删除字段，因此，删除定义后，WCDB只是将该字段忽略，其旧数据依然存在在数据库内，
// 但新增加的数据基本不会因为该字段产生额外的性能和空间损耗。


@implementation LJCGameModel

WCDB_IMPLEMENTATION(LJCGameModel)
WCDB_SYNTHESIZE(LJCGameModel, gameId)
WCDB_SYNTHESIZE(LJCGameModel, gameName)
WCDB_SYNTHESIZE(LJCGameModel, gameDescription)
WCDB_SYNTHESIZE(LJCGameModel, gameFollow)

//WCDB_PRIMARY(LJCGameModel, gameId)                  //主键
WCDB_PRIMARY_AUTO_INCREMENT(LJCGameModel, gameId)   //主键自增，AUTOINCREMENT is only allowed on an INTEGER PRIMARY KEY

- (BOOL)ljc_isAutoIncrement
{
    return self.isAutoIncrement;
}
- (void)ljc_setIsAutoIncrement:(BOOL)isAutoIncrement
{
    self.isAutoIncrement = isAutoIncrement;
}

@end
