//
//  LJCDoctorModel.mm
//  LJCDBStore
//
//  Created by 林锦超 on 25/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorModel+WCTTableCoding.h"
#import "LJCDoctorModel.h"

@implementation LJCDoctorModel

WCDB_IMPLEMENTATION(LJCDoctorModel)
WCDB_SYNTHESIZE(staffNo)
WCDB_SYNTHESIZE(avatarURL)
WCDB_SYNTHESIZE(name)
WCDB_SYNTHESIZE(sex)
WCDB_SYNTHESIZE(introduce)
WCDB_SYNTHESIZE(speciality)
WCDB_SYNTHESIZE(hospitalCode)
WCDB_SYNTHESIZE(hospitalName)
WCDB_SYNTHESIZE(deptCode)
WCDB_SYNTHESIZE(deptName)

WCDB_PRIMARY(staffNo);
@end
