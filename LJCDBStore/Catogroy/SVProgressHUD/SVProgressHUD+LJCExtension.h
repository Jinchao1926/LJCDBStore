//
//  SVProgressHUD+LJCExtension.h
//  LJCDBStore
//
//  Created by 林锦超 on 26/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (LJCExtension)


// Extension
+ (void)showAwhile;
+ (void)showWithDuration:(NSTimeInterval)duration;
+ (void)showWithDuration:(NSTimeInterval)duration completion:(SVProgressHUDDismissCompletion)completion;
@end
