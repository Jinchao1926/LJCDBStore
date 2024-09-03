//
//  LJCDoctorRequest.h
//  LJCDBStore
//
//  Created by 林锦超 on 29/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCRequest.h"

@interface LJCDoctorRequest : LJCRequest

- (instancetype)initWithPage:(NSInteger)page limit:(NSInteger)limit;
- (instancetype)initWithPage:(NSInteger)page;
@end
