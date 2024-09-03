//
//  LJCDoctorStore.m
//  LJCDBStore
//
//  Created by 林锦超 on 30/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorStore.h"
#import "LJCStoreManager.h"
#import "LJCDoctorModel.h"
#import "LJCDoctorModel+WCTTableCoding.h"

static NSString *const kTableDoctor = @"Doctor";

@implementation LJCDoctorStore

+ (void)initialize
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    [database createTableAndIndexesOfName:kTableDoctor withClass:LJCDoctorModel.class];
}

+ (NSArray<LJCDoctorModel *> *)doctorsWithRange:(NSRange)range
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        return [database getObjectsOfClass:LJCDoctorModel.class fromTable:kTableDoctor limit:range.length offset:range.location];
    }
    return @[];
}

+ (BOOL)insertDoctors:(NSArray<LJCDoctorModel *> *)doctors
{
    WCTDatabase *database = [LJCStoreManager sharedManager].database;
    if ([database canOpen]) {
        [database insertObjects:doctors into:kTableDoctor];
    }
    return NO;
}
@end
