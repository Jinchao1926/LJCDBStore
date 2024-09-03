//
//  LJCChatFTSModel.h
//  LJCDBStore
//
//  Created by 林锦超 on 02/01/2018.
//  Copyright © 2018 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJCChatModel;
@interface LJCChatFTSModel : NSObject

@property (nonatomic, assign) NSInteger chatId;         ///< 本地id，包含上传失败的记录，作为主键

///< 文本内容
@property (nonatomic, copy) NSString *content;

+ (LJCChatFTSModel *)ftsModelWithOrigin:(LJCChatModel *)origin;
@end
