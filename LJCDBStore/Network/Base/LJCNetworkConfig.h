//
//  LJCNetworkConfig.h
//  LJCDBStore
//
//  Created by 林锦超 on 30/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#ifndef LJCNetworkConfig_h
#define LJCNetworkConfig_h

#define LJC_NETWORK_ALPHA   0
#define LJC_NETWORK_BETA    0


#if LJC_NETWORK_ALPHA   //内网
    #define LJC_BASE_URL     @"http://192.168.6.229:8080/telemedicine-server"

#elif LJC_NETWORK_BETA  //外网测试
    #define LJC_BASE_URL     @"http://114.215.253.239:86/telemedicine-server"

#else
    #define LJC_BASE_URL     @"http://server.yimed.cn/server"
#endif

#endif /* LJCNetworkConfig_h */
