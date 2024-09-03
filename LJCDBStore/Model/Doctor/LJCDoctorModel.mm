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
WCDB_SYNTHESIZE(LJCDoctorModel, staffNo)
WCDB_SYNTHESIZE(LJCDoctorModel, avatarURL)
WCDB_SYNTHESIZE(LJCDoctorModel, name)
WCDB_SYNTHESIZE(LJCDoctorModel, sex)
WCDB_SYNTHESIZE(LJCDoctorModel, introduce)
WCDB_SYNTHESIZE(LJCDoctorModel, speciality)
WCDB_SYNTHESIZE(LJCDoctorModel, hospitalCode)
WCDB_SYNTHESIZE(LJCDoctorModel, hospitalName)
WCDB_SYNTHESIZE(LJCDoctorModel, deptCode)
WCDB_SYNTHESIZE(LJCDoctorModel, deptName)

WCDB_PRIMARY(LJCDoctorModel, staffNo);
@end
