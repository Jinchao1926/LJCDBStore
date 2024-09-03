//
//  LJCDoctorRequestManager.m
//  LJCDBStore
//
//  Created by 林锦超 on 29/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorRequestManager.h"
#import "LJCDoctorRequest.h"
#import "LJCDoctorStore.h"
#import "LJCDoctorModel.h"

@interface LJCDoctorRequestManager()
@property (nonatomic, strong) LJCDoctorRequest *request;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger limit;
@end

@implementation LJCDoctorRequestManager

- (void)dealloc
{
    NSLog(@"dealloc LJCDoctorRequestManager");
    
    [_request stop];
}

- (instancetype)init
{
    if (self = [super init]) {
        _page = 1;
        _limit = 30;
    }
    return self;
}

- (void)fetchFirstPageDoctorsWithCompletion:(LJCDoctorRequestManagerCompletionHandler)handler
{
    [self fetchDoctorsWithPage:(_page = 1) completion:handler];
}

- (void)fetchNextPageDoctorsWithCompletion:(LJCDoctorRequestManagerCompletionHandler)handler
{
    [self fetchDoctorsWithPage:++_page completion:handler];
}

- (void)fetchDoctorsWithPage:(NSInteger)page completion:(LJCDoctorRequestManagerCompletionHandler)handler
{
    // db cache
    NSArray<LJCDoctorModel *> *datas = [LJCDoctorStore doctorsWithRange:NSMakeRange(_limit * (_page - 1), _limit)];
    if (datas.count > 0) {
        NSLog(@"db cached");
        if (handler) {
            handler(datas);
        }
        return;
    }
    
    // 上一次请求正在执行
    if (_request.isExecuting) {
        return;
    }
    
    // http request
    _request = [[LJCDoctorRequest alloc] initWithPage:page];
    [_request startWithCompletionBlock:^(__kindof LJCRequest *request) {
        NSArray<LJCDoctorModel *> *datas = nil;
        if (request.isResponseJSONSuccess) {
            datas = [LJCDoctorModel mj_objectArrayWithKeyValuesArray:request.responseJSONEntity];
            if (datas.count > 0) {
                // db store
                NSLog(@"insertDoctors");
                for (LJCDoctorModel *aModel in datas) {
                    aModel.avatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/image/getIcon/1/%@", LJC_BASE_URL, aModel.staffNo]];
                }
                [LJCDoctorStore insertDoctors:datas];
            }
        }
        
        if (handler) {
            handler(datas);
        }
    }];
}
@end
