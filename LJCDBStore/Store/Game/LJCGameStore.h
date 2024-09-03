//
//  LJCGameStore.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJCGameModel;
@interface LJCGameStore : NSObject

//MARK: Table
+ (BOOL)dropGameTable;

//MARK: Select
+ (NSArray *)allGames;

//MARK: Insert
+ (BOOL)insertGame:(LJCGameModel *)game;
+ (BOOL)insertGames:(NSArray<LJCGameModel *> *)games;

//MARK: Delete
+ (BOOL)deleteGame:(NSString *)gameId;
+ (BOOL)deleteAllGames;

//MARK: Update
+ (BOOL)updateYoGiOhToOnePiece;
@end
