//
//  LJCDoctorModel+WCTTableCoding.h
//  LJCDBStore
//
//  Created by 林锦超 on 25/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorModel.h"
#import <WCDBObjc/WCDBObjc.h>

@interface LJCDoctorModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(staffNo)
WCDB_PROPERTY(name)
WCDB_PROPERTY(sex)
WCDB_PROPERTY(introduce)
WCDB_PROPERTY(speciality)
@end
