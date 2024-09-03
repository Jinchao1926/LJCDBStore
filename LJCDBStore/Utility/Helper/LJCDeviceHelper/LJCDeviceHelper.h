//
//  YJDeviceHelper.h
//  telemedicineDoctor
//
//  Created by 林锦超 on 14/08/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJCDeviceHelper : NSObject

+ (instancetype)sharedHelper;

/**< 获取设备UUID */
@property (nonatomic, copy, readonly) NSString *uuid;
/**< 获取App名称 */
@property (nonatomic, copy, readonly) NSString *appName;
/**< 获取APP版本，eg 1.5.0 */
@property (nonatomic, copy, readonly) NSString *appVersion;
/**< 获取操作系统版本，eg 10.0 */
@property (nonatomic, copy, readonly) NSString *systemVersion;
/**< 获取操作系统名称，eg iOS */
@property (nonatomic, copy, readonly) NSString *systemName;
/**< systemVersion + systemName，eg iOS 9.2 */
@property (nonatomic, copy, readonly) NSString *totalSystemVersion;

/**< 获取设备型号, eg iPhone 6s、iPhone 6s Plus、x86_64（模拟器）... */
@property (nonatomic, copy, readonly) NSString *deviceVersion;
/**< 获取设备前后置摄像头像素（前置;后置），eg 1200000;12000000... */
@property (nonatomic, copy, readonly) NSString *deviceCameraPixels;
/**< 获取设备屏幕大小（height*width）eg，667*375 */
@property (nonatomic, copy, readonly) NSString *deviceScreenSize;

@end
