//
//  LJCChatHelper.h
//  LJCDBStore
//
//  Created by 林锦超 on 29/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJCChatHelper : NSObject

+ (NSRegularExpression *)regexAt;
+ (NSRegularExpression *)regexTopic;
+ (NSRegularExpression *)regexURL;
+ (NSRegularExpression *)regexEmail;
+ (NSRegularExpression *)regexEmoticon;

+ (NSString *)stringWithTimelineDate:(NSDate *)date;
+ (UIImage *)bubbleImageWithMessageFrom:(BOOL)isOwnMessage;

+ (NSBundle *)emoticonBundle;
///< [大哭] : @"xxx.png"
+ (NSDictionary<NSString *, NSString *> *)emoticonPaths;


+ (UIImage *)imageWithPath:(NSString *)path;
@end
