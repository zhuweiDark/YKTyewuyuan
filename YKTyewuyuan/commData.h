//
//  commData.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-18.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#ifndef CMdriverPro_commData_h
#define CMdriverPro_commData_h

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS7_AVAILABLE (SYSTEM_VERSION >= 7.0) //运行时判断系统iOS版本是否为7.0以上
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000   //编译时，有使用iOS7的方法需要用 (#ifdef IOS7_SDK_AVAILABLE  #endif) 判断
#define IOS7_SDK_AVAILABLE 1
#endif


#endif
