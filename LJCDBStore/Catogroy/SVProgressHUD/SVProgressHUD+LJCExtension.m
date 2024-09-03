//
//  SVProgressHUD+LJCExtension.m
//  LJCDBStore
//
//  Created by 林锦超 on 26/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "SVProgressHUD+LJCExtension.h"

@implementation SVProgressHUD (LJCExtension)

+ (void)initialize
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:1.f];
//      [SVProgressHUD setImageViewSize:CGSizeMake(64, 64)];
}

+ (void)showAwhile
{
    [SVProgressHUD showWithDuration:1.f];
}

+ (void)showWithDuration:(NSTimeInterval)duration
{
    [SVProgressHUD showWithDuration:duration completion:nil];
}

+ (void)showWithDuration:(NSTimeInterval)duration completion:(SVProgressHUDDismissCompletion)completion
{
    [SVProgressHUD show];
    [SVProgressHUD dismissWithDelay:duration completion:completion];
}
@end
