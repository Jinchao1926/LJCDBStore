//
//  LJCDoctorModel.h
//  LJCDBStore
//
//  Created by 林锦超 on 25/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJCBaseModel.h"

@interface LJCDoctorModel : LJCBaseModel

@property (nonatomic, copy) NSString *staffNo;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;                //1-男，0-女
@property (nonatomic, copy) NSString *introduce;          //简介
@property (nonatomic, copy) NSString *speciality;         //擅长
@property (nonatomic, copy) NSString *memo;               //备注

@property (nonatomic, copy) NSString *hospitalCode;
@property (nonatomic, copy) NSString *hospitalName;
@property (nonatomic, copy) NSString *jobLevel;
@property (nonatomic, copy) NSString *jobLevelName;
@property (nonatomic, copy) NSString *deptCode;
@property (nonatomic, copy) NSString *deptName;
@end
