//
//  LJCDoctorRequestManager.h
//  LJCDBStore
//
//  Created by 林锦超 on 29/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJCDoctorModel;
typedef void(^LJCDoctorRequestManagerCompletionHandler)(NSArray<LJCDoctorModel *> *datas);

@interface LJCDoctorRequestManager : NSObject

- (void)fetchFirstPageDoctorsWithCompletion:(LJCDoctorRequestManagerCompletionHandler)handler;
- (void)fetchNextPageDoctorsWithCompletion:(LJCDoctorRequestManagerCompletionHandler)handler;
/// 查询在线医生列表
//- (void)fetchDoctorsWithPage:(NSInteger)page completion:(LJCDoctorRequestManagerCompletionHandler)handler;
@end
