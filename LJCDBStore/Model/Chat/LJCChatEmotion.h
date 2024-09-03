//
//  LJCEmotion.h
//  LJCDBStore
//
//  Created by 林锦超 on 30/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJCChatEmotionGroup;

typedef NS_ENUM(NSUInteger, LJCEmoticonType)
{
    LJCEmoticonTypeImage = 0, ///< 图片表情
    LJCEmoticonTypeEmoji = 1, ///< Emoji表情
};

@interface LJCChatEmotion : NSObject
@property (nonatomic, strong) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, strong) NSString *cht;  ///< 例如 [吃驚]
@property (nonatomic, strong) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, strong) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, strong) NSString *code; ///< 例如 0x1f60d
@property (nonatomic, assign) LJCEmoticonType type;
@property (nonatomic, weak) LJCChatEmotionGroup *group; ///< 保存分组id，用于 bundle 中获取表情
@end

@interface LJCChatEmotionGroup : NSObject
@property (nonatomic, strong) NSString *groupID; ///< 例如 com.sina.default
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSString *nameCN;  ///< 例如 浪小花
@property (nonatomic, strong) NSString *nameEN;
@property (nonatomic, strong) NSString *nameTW;
@property (nonatomic, assign) NSInteger displayOnly;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSArray<LJCChatEmotion *> *emoticons;
@end
