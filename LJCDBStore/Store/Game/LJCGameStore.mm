//
//  LJCGameStore.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCGameStore.h"
#import "LJCStoreManager.h"
#import "LJCGameModel.h"
#import "LJCGameModel+WCTTableCoding.h"

// 不抽离父类，统一声明 "LJCStoreManager.h"
// 会导致每个用到Store的view或者Controller都要写成.mm

static NSString *const kTableGame = @"Game";

@implementation LJCGameStore

//MARK: Table
+ (void)initialize
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    
    // WCDB内部会自动判断表是否存在，同时还会判断 ORM 映射是否新增了字段
//    if (![database isTableExists:kTableGame]) {
        [database createTable:kTableGame withClass:LJCGameModel.class];
//    }
}

+ (BOOL)dropGameTable
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database dropTable:kTableGame];
    }
    return NO;
}

//MARK: Select
+ (NSArray *)allGames
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database getObjectsOfClass:LJCGameModel.class fromTable:kTableGame orders:LJCGameModel.gameId.asOrder(WCTOrderedAscending)];
//        return [database getAllObjectsOfClass:LJCGameModel.class fromTable:kTableGame];
    }
    return @[];
}

//MARK: Insert
+ (BOOL)insertGame:(LJCGameModel *)game
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database insertObject:(WCTObject *)game intoTable:kTableGame];
    }
    return NO;
}

+ (BOOL)insertGames:(NSArray<LJCGameModel *> *)games
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database insertObjects:games intoTable:kTableGame];
    }
    return NO;
}

//MARK: Delete
+ (BOOL)deleteGame:(NSString *)gameId;
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database deleteFromTable:kTableGame where:LJCGameModel.gameId == gameId];
    }
    return NO;
}

+ (BOOL)deleteAllGames
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database deleteFromTable:kTableGame];
    }
    return NO;
}

//MARK: Update
+ (BOOL)updateYoGiOhToOnePiece
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        LJCGameModel *game = [[LJCGameModel alloc] init];
        game.gameName = @"新海贼王";
        game.gameDescription = @"新海贼王（From 游戏王）";
//        WCTPropertyList list;
//        list.push_back(LJCGameModel.gameName);
//        list.push_back(LJCGameModel.gameDescription);
        return [database updateTable:kTableGame
                       setProperties:{ LJCGameModel.gameName, LJCGameModel.gameDescription }
                            toObject:game
                               where:LJCGameModel.gameName == @"游戏王"];
    }
    return NO;
}
@end
