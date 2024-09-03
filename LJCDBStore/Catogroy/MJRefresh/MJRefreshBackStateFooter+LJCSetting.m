//
//  MJRefreshBackStateFooter+LJCSetting.m
//  LJCDBStore
//
//  Created by 林锦超 on 30/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "MJRefreshBackStateFooter+LJCSetting.h"

@implementation MJRefreshBackStateFooter (LJCSetting)

- (instancetype)init
{
    if (self = [super init]) {
        self.stateLabel.hidden = YES;
//        self.triggerAutomaticallyRefreshPercent;
    }
    return self;
}
@end
