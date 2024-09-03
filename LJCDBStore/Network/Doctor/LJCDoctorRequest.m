//
//  LJCDoctorRequest.m
//  LJCDBStore
//
//  Created by 林锦超 on 29/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorRequest.h"

@interface LJCDoctorRequest()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limit;
@end

@implementation LJCDoctorRequest

- (instancetype)initWithPage:(NSInteger)page limit:(NSInteger)limit
{
    if (self = [super init]) {
        _page = page;
        _limit = limit;
        
        self.showRequestHUD = YES;
    }
    return self;
}

- (instancetype)initWithPage:(NSInteger)page
{
    return [self initWithPage:page limit:5];
}

- (instancetype)init
{
    return [self initWithPage:0];
}

#pragma mark - Settings
- (NSString *)requestUrl
{
    // “ http://114.215.253.239:86/telemedicine-server ” 在 YTKNetworkConfig 中设置，这里只填除去域名剩余的网址信息
    return @"doctor/searchDoctors";
}

- (id)requestArgument
{
    return @{ @"pageNum" : @(_page),
              @"limit" : @(_limit) };
}

// Code=-9 "Invalid JSON format"
- (id)jsonValidator
{
    return @{ @"entity" : [NSArray class] };
    
    /*
    return @[@{
                 @"id": [NSNumber class],
                 @"imageId": [NSString class],
                 @"time": [NSNumber class],
                 @"status": [NSNumber class],
                 @"question": @{
                         @"id": [NSNumber class],
                         @"content": [NSString class],
                         @"contentType": [NSNumber class]
                         }
                 }];
     */
}
@end
