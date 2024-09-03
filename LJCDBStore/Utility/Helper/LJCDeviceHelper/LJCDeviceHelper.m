//
//  YJDeviceHelper.m
//  telemedicineDoctor
//
//  Created by 林锦超 on 14/08/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDeviceHelper.h"
#import "sys/utsname.h"

@interface LJCDeviceHelper()

@property (nonatomic, copy, readwrite) NSString *uuid;
@property (nonatomic, copy, readwrite) NSString *appName;
@property (nonatomic, copy, readwrite) NSString *appVersion;
@property (nonatomic, copy, readwrite) NSString *systemVersion;
@property (nonatomic, copy, readwrite) NSString *systemName;
@property (nonatomic, copy, readwrite) NSString *totalSystemVersion;
@property (nonatomic, copy, readwrite) NSString *deviceVersion;
@property (nonatomic, copy, readwrite) NSString *deviceCameraPixels;
@property (nonatomic, copy, readwrite) NSString *deviceScreenSize;
@end
@implementation LJCDeviceHelper

+ (instancetype)sharedHelper
{
    static LJCDeviceHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[[self class] alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    if (self = [super init]) {
        _deviceVersion = [self p_deviceVersion];
        _deviceCameraPixels = [self p_deviceCameraPixels];
        _deviceScreenSize = [self p_deviceScreenSize];
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        _appName = [infoDict objectForKey:@"CFBundleDisplayName"];
        _appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        _systemVersion = [[UIDevice currentDevice] systemVersion];
        _systemName = [[UIDevice currentDevice] systemName];
        _totalSystemVersion = [NSString stringWithFormat:@"%@ %@", _systemName, _systemVersion]; //iPhone OS 9.2
        _uuid =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p\n uuid: %@\n appVersion: %@\n systemVersion: %@\n systemName: %@\n totalSystemVersion: %@\n deviceVersion: %@\n deviceCameraPixels: %@\n deviceScreenSize: %@>",
            [self class], self, self.uuid, self.appVersion, self.systemVersion, self.systemName, self.totalSystemVersion,
            self.deviceVersion, self.deviceCameraPixels, self.deviceScreenSize];
}

#pragma mark - Private
/**
 *  获取设备型号
 *
 *  @return 设备型号
 */
- (NSString *)p_deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    return deviceString;
}

/**
 *  获取设备前后置摄像头像素
 *
 *  @return 前置;后置
 */
- (NSString *)p_deviceCameraPixels
{
    NSString *pixel = nil;
    NSString *deviceVersion = [self deviceVersion];
    if ([deviceVersion isEqualToString:@"iPhone 5S"] ||
        [deviceVersion isEqualToString:@"iPhone 5C"] ||
        [deviceVersion isEqualToString:@"iPhone 5"]  ||
        [deviceVersion isEqualToString:@"iPhone 6"]  ||
        [deviceVersion isEqualToString:@"iPhone 6s Plus"])
    {
        pixel = @"1200000;8000000";
    }
    else if ([deviceVersion isEqualToString:@"iPhone 6s"] ||
             [deviceVersion isEqualToString:@"iPhone 6s Plus"])
    {
        pixel = @"5000000;12000000";
    }
    else if ([deviceVersion isEqualToString:@"iPhone 7"] ||
             [deviceVersion isEqualToString:@"iPhone 7 Plus"])
    {
        pixel = @"7000000;12000000";
    }
    else if ([deviceVersion isEqualToString:@"iPhone SE"])
    {
        pixel = @"1200000;12000000";
    }
    else if ([deviceVersion isEqualToString:@"iPhone 8"] ||
             [deviceVersion isEqualToString:@"iPhone 8 Plus"] ||
             [deviceVersion isEqualToString:@"iPhone X"])
    {
        pixel = @"7000000;12000000";
    }
    return pixel;
}

/**
 *  获取设备屏幕大小
 *
 *  @return height*width
 */
- (NSString *)p_deviceScreenSize
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    return [NSString stringWithFormat:@"%.f*%.f", size.height, size.width];
}

@end
