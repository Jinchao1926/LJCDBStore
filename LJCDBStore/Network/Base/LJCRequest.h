//
//  LJCRequest.h
//  LJCDBStore
//
//  Created by 林锦超 on 30/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@class LJCRequest;
typedef void(^LJCRequestCompletionBlock)(__kindof LJCRequest *request);

@interface LJCRequest : YTKRequest

/// return responseJSONObject[@"success"]
@property (nonatomic, assign, getter=isResponseJSONSuccess, readonly) BOOL responseJSONSuccess;

/// return responseJSONObject[@"entity"]
@property (nonatomic, strong, readonly) NSString *responseJSONEntity;

/// return responseJSONObject[@"message"]
@property (nonatomic, strong, readonly) NSString *responseJSONMessage;

/// return responseJSONObject[@"errorCode"]
@property (nonatomic, strong, readonly) NSString *responseJSONErrorCode;

/// show SVProgressHUD when request, default NO.
@property (nonatomic, assign, getter=isShowRequestHUD) BOOL showRequestHUD;


///  Convenience method to start the request with block callbacks.
///  responseJSONSuccess means success or not.
- (void)startWithCompletionBlock:(LJCRequestCompletionBlock)handler;

- (void)LJCSuccessLog;
- (void)LJCErrorLog;

@end
