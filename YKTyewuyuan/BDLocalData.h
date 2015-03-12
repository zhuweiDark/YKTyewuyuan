//
//  BDLocalData.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-14.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDLocalData : NSObject

@property (nonatomic,strong)NSMutableArray * shengArr;

+ (BDLocalData *) initWithDataPlist:(NSString *)plist;
@end

@interface BDShengData : NSObject
@property (nonatomic,strong)NSString * shengName;
@property (nonatomic,strong)NSString * shengCode;
@property (nonatomic,strong)NSMutableArray * cityArr;

@end
@interface BDCityData : NSObject

@property (nonatomic,strong)NSString * cityName;
@property (nonatomic,strong)NSString * cityCode;
@end