//
//  IQKeyboardManager+LJCAppearance.m
//  LJCDBStore
//
//  Created by 林锦超 on 22/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "IQKeyboardManager+LJCAppearance.h"
#import "LJCChatViewController.h"

@implementation IQKeyboardManager (LJCAppearance)

+ (void)initialize
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    if (@available(iOS 11.0, *)) {
        [IQKeyboardManager sharedManager].canAdjustAdditionalSafeAreaInsets = YES;
    }
//    [IQKeyboardManager sharedManager].enableDebugging = YES;
    
    // disable
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[LJCChatViewController class]];
}

@end
