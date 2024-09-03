//
//  MWPhoto+LJCExtension.m
//  LJCDBStore
//
//  Created by 林锦超 on 12/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "MWPhoto+LJCExtension.h"
#import <objc/runtime.h>

@implementation MWPhoto (LJCExtension)

static char kTagKey;

- (void)setTag:(NSInteger)tag
{
    objc_setAssociatedObject(self, @selector(tag), @(tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)tag
{
    NSNumber *tag = objc_getAssociatedObject(self, @selector(tag));
    return tag.integerValue;
}

@end
