//
//  LJCStoreManager.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDBObjc/WCDBObjc.h>

@interface LJCStoreManager : NSObject

@property (nonatomic, strong) WCTDatabase *database;

+ (instancetype)sharedManager;
@end
