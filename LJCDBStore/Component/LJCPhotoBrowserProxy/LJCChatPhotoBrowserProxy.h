//
//  LJCChatPhotoBrowserProxy.h
//  LJCDBStore
//
//  Created by 林锦超 on 11/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCPhotoBrowserProxy.h"

@interface LJCChatPhotoBrowserProxy : LJCPhotoBrowserProxy

- (instancetype)initWithChatId:(NSString *)chatId;
- (void)presentPhotoBrowserWithChatId:(NSInteger)chatId;
@end
