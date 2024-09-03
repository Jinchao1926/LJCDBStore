//
//  NSString+LJCDateString.m
//  LJCDBStore
//
//  Created by 林锦超 on 06/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "NSString+LJCDateString.h"

@implementation NSString (LJCDateString)

+ (NSString *)stringWithCurrentDate
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyyMMddHHmmssSSSS";
    });
    return [formatter stringFromDate:[NSDate date]];
}

@end
