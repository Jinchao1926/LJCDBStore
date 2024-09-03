//
//  LJCGameModel+WCTTableCoding.h
//  LJCDBStore
//
//  Created by 林锦超 on 24/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCGameModel.h"
#import <WCDB/WCDB.h>

/*
 利用分类，而不是直接定义在头文件，
 可以使得View／Controller不用改成.mm
 */

/*
 定义该类遵循WCTTableCoding协议。可以在类声明上定义，也可以通过文件模版在category内定义。
 使用WCDB_PROPERTY宏在头文件声明需要绑定到数据库表的字段。
 使用WCDB_IMPLEMENTATIO宏在类文件定义绑定到数据库表的类。
 使用WCDB_SYNTHESIZE宏在类文件定义需要绑定到数据库表的字段。
 */

@interface LJCGameModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(gameId)
WCDB_PROPERTY(gameName)
WCDB_PROPERTY(gameDescription)
WCDB_PROPERTY(gameFollow)
@end
