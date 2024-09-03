//
//  LJCDoctorYYLayout.h
//  LJCDBStore
//
//  Created by 林锦超 on 20/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJCDoctorModel.h"

#define kYYCellMargin       10

#define kYYCellAvatarMargin 12
#define kYYCellAvatarSize   48

#define kYYCellNameMargin   12
#define kYYCellNameHeight   22
#define kYYCellNameWidth    (kScreenWidth - kYYCellMargin * 2 - kYYCellAvatarMargin - kYYCellAvatarSize - kYYCellNameMargin * 2)

#define kYYCellHospitalDeptHeight 23

#define kYYCellNameFontSize kYYCellNameHeight
#define kYYCellHospitalDeptFontSize kYYCellHospitalDeptHeight
#define kYYCellIntroduceFontSize  kYYCellIntroduceMargin

@interface LJCDoctorYYLayout : NSObject

///< 数据
@property (nonatomic, strong) LJCDoctorModel *doctor;

// 顶部留白
@property (nonatomic, assign) CGFloat marginTop; //顶部灰色留白

///< container
@property (nonatomic, assign) CGSize containerSize;
@property (nonatomic, strong) YYTextLayout *containerLayout;

///< 姓名
@property (nonatomic, assign) CGFloat nameHeight;
@property (nonatomic, strong) YYTextLayout *nameLayout;

///< 科室
@property (nonatomic, assign) CGFloat hospitalDeptHeight;
@property (nonatomic, strong) YYTextLayout *hospitalDeptLayout;

///< 简介
@property (nonatomic, assign) CGFloat introduceHeight;
@property (nonatomic, strong) YYTextLayout *introduceLayout;

// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白

// 总高度
@property (nonatomic, assign) CGFloat height;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDoctor:(LJCDoctorModel *)doctor;
@end


