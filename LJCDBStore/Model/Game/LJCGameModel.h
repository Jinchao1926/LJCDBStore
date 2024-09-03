//
//  LJCGameModel.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <WCDB/WCDB.h>

@interface LJCGameModel : NSObject

@property (nonatomic, assign) NSInteger gameId;
@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, copy) NSString *gameDescription;
@property (nonatomic, assign) NSInteger gameFollow;

- (BOOL)ljc_isAutoIncrement;
- (void)ljc_setIsAutoIncrement:(BOOL)isAutoIncrement;
@end
