//
//  LJCChatHelper.m
//  LJCDBStore
//
//  Created by 林锦超 on 29/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatHelper.h"
#import "LJCChatEmotion.h"

@implementation LJCChatHelper

#pragma mark - regex
+ (NSRegularExpression *)regexAt
{
    static NSRegularExpression *regexAt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regexAt = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regexAt;
}

+ (NSRegularExpression *)regexTopic
{
    static NSRegularExpression *regexTopic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regexTopic = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
    });
    return regexTopic;
}

+ (NSRegularExpression *)regexURL
{
    static NSRegularExpression *regexURL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regexURL = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:kNilOptions error:NULL];
    });
    return regexURL;
}

+ (NSRegularExpression *)regexEmail
{
    static NSRegularExpression *regexEmail;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        regexEmail = [NSRegularExpression regularExpressionWithPattern:@"[-_a-zA-Z@\\.]+[ ,\\n]" options:kNilOptions error:NULL];
        regexEmail = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$" options:kNilOptions error:NULL];
    });
    return regexEmail;
}

+ (NSRegularExpression *)regexEmoticon
{
    static NSRegularExpression *regexEmoticon;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regexEmoticon = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regexEmoticon;
}

#pragma mark - timeline
+ (NSString *)stringWithTimelineDate:(NSDate *)date
{
    if (!date) return @"";
    
    static NSDateFormatter *formatterYesterday;
    static NSDateFormatter *formatterSameYear;
    static NSDateFormatter *formatterFullDate;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterYesterday = [[NSDateFormatter alloc] init];
        [formatterYesterday setDateFormat:@"昨天 HH:mm"];
        [formatterYesterday setLocale:[NSLocale currentLocale]];
        
        formatterSameYear = [[NSDateFormatter alloc] init];
        [formatterSameYear setDateFormat:@"MM-dd"];
        [formatterSameYear setLocale:[NSLocale currentLocale]];
        
        formatterFullDate = [[NSDateFormatter alloc] init];
//        [formatterFullDate setDateFormat:@"yyyy-MM-dd"];
        [formatterFullDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    return [formatterFullDate stringFromDate:date];
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // 本地时间有问题
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60 * 10) { // 10分钟内
        return @"刚刚";
    } else if (delta < 60 * 60) { // 1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)(delta / 60.0)];
    } else if (date.isToday) {
        return [NSString stringWithFormat:@"%d小时前", (int)(delta / 60.0 / 60.0)];
    } else if (date.isYesterday) {
        return [formatterYesterday stringFromDate:date];
    } else if (date.year == now.year) {
        return [formatterSameYear stringFromDate:date];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

#pragma mark - bubble
+ (UIImage *)bubbleImageWithMessageFrom:(BOOL)isOwnMessage
{
    // 72 * 88
    static UIImage *senderBubbleImage = nil;
    static UIImage *receiveBubbleImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        senderBubbleImage = [self p_bubbleImageWithMessageFrom:YES];
        receiveBubbleImage = [self p_bubbleImageWithMessageFrom:NO];
    });
    
    return isOwnMessage ? senderBubbleImage : receiveBubbleImage;
}

+ (UIImage *)p_bubbleImageWithMessageFrom:(BOOL)isOwnMessage
{
    // 72 * 88
//    UIImage *bubbleImage = [UIImage imageNamed:(isOwnMessage ? @"message_sender_bg" : @"message_receiver_bg")];
    UIImage *bubbleImage = [UIImage imageNamed:(isOwnMessage ? @"IMSenderTextBubble" : @"IMReceiverTextBubble")];
    
    CGFloat x = floorf(bubbleImage.size.width * (isOwnMessage ? 30 : 41) / 72);
    CGFloat y = floorf(bubbleImage.size.height * 54 / 80);
    UIImage *resizeImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(y, x, x, y) resizingMode:UIImageResizingModeStretch];
    return resizeImage;
}

#pragma mark - cache

/*
+ (UIImage *)imageNamed:(NSString *)name
{
    if (!name) {
        return nil;
    }
    ///< 缓存
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) {
        return image;
    }
    
    NSString *ext = name.pathExtension;
    if (ext.length == 0) {
        ext = @"png";
    }
    NSString *path = [[self emoticonBundle] pathForScaledResource:name ofType:ext];
    if (!path) {
        return nil;
    }
    
    image = [UIImage imageWithContentsOfFile:path];
    image = [image imageByDecoded];
    if (!image) {
        return nil;
    }
    [[self imageCache] setObject:image forKey:name];
    return image;
}
 */

+ (UIImage *)imageWithPath:(NSString *)path
{
    if (!path) {
        return nil;
    }
    
    UIImage *image = [[YYCache chatEmoticonCache] objectForKey:path];
    if (image) {
        return image;
    }
    
    if (path.pathScale == 1) {
        // 查找 @2x @3x 的图片
        NSArray *scales = [NSBundle preferredScales];   //@[@2,@3,@1]
        for (NSNumber *scale in scales) {
            image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathScale:scale.floatValue]];
            if (image) break;
        }
    } else {
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image) {
        image = [image imageByDecoded];
        [[YYCache chatEmoticonCache] setObject:image forKey:path];
    }
    return image;
}

#pragma mark - emoticon
+ (NSBundle *)emoticonBundle
{
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    });
    return bundle;
}

+ (NSDictionary *)emoticonPaths
{
    static NSMutableDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        dict = [self p_emoticonDictionaryFromPath:emoticonBundlePath];
    });
    return dict;
}

+ (NSMutableDictionary *)p_emoticonDictionaryFromPath:(NSString *)path
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    LJCChatEmotionGroup *group = nil;
    NSString *jsonPath = [path stringByAppendingPathComponent:@"info.json"];
    NSData *json = [NSData dataWithContentsOfFile:jsonPath];
    if (json.length) {
        group = [LJCChatEmotionGroup mj_objectWithKeyValues:json];
    }
    if (!group) {
        NSString *plistPath = [path stringByAppendingPathComponent:@"info.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (plistDict.count) {
            group = [LJCChatEmotionGroup mj_objectWithKeyValues:plistDict];
        }
    }
    
    for (LJCChatEmotion *emoticon in group.emoticons) {
        if (emoticon.png.length == 0) {
            continue;
        }
        
        NSString *pngPath = [path stringByAppendingPathComponent:emoticon.png];
        if (emoticon.chs) {
            dict[emoticon.chs] = pngPath;
        }
        if (emoticon.cht) {
            dict[emoticon.cht] = pngPath;
        }
    }
    
    NSArray *folders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *folder in folders) {
        if (folder.length == 0) {
            continue;
        }
        
        NSDictionary *subDict = [self p_emoticonDictionaryFromPath:[path stringByAppendingPathComponent:folder]];
        if (subDict) {
            [dict addEntriesFromDictionary:subDict];
        }
    }
    return dict;
}

@end
