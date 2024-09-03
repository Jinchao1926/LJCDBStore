//
//  MJRefreshStateHeader+LJCSetting.m
//  LJCDBStore
//
//  Created by 林锦超 on 30/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "MJRefreshStateHeader+LJCSetting.h"

@implementation MJRefreshStateHeader (LJCSetting)

- (instancetype)init
{
    if (self = [super init]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
    }
    return self;
}
@end
