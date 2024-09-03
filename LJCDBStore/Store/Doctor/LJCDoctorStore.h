//
//  LJCDoctorStore.h
//  LJCDBStore
//
//  Created by 林锦超 on 30/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJCDoctorModel;
@interface LJCDoctorStore : NSObject

+ (NSArray<LJCDoctorModel *> *)doctorsWithRange:(NSRange)range;

//MARK: Insert
+ (BOOL)insertDoctors:(NSArray<LJCDoctorModel *> *)doctors;
@end
