//
//  LJCEmotion.m
//  LJCDBStore
//
//  Created by 林锦超 on 30/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatEmotion.h"

@implementation LJCChatEmotion

- (NSString *)description
{
    return [NSString stringWithFormat:@"< %@:%p chs:%@ cht:%@ code:%@ >", self.class, self, self.chs, self.cht, self.code];
}
@end

@implementation LJCChatEmotionGroup

- (instancetype)init
{
    if (self = [super init]) {
        [LJCChatEmotionGroup mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"emoticons" : @"LJCChatEmotion" };
        }];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"< %@:%p groupID:%@ nameCN:%@ emoticons:%@ >", self.class, self, self.groupID, self.nameCN, self.emoticons];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"groupID" : @"id",
              @"nameCN" : @"group_name_cn",
              @"nameEN" : @"group_name_en",
              @"nameTW" : @"group_name_tw",
              @"displayOnly" : @"display_only",
              @"groupType" : @"group_type" };
}

- (void)setEmoticons:(NSArray<LJCChatEmotion *> *)emoticons
{
    _emoticons = emoticons;

    [_emoticons enumerateObjectsUsingBlock:^(LJCChatEmotion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.group = self;
    }];
}
@end
