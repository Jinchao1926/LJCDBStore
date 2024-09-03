//
//  UITableView+LJCAppearance.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "UITableView+LJCAppearance.h"

@implementation UITableView (LJCAppearance)

+ (void)initialize
{
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    [UITableView appearance].tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
@end
