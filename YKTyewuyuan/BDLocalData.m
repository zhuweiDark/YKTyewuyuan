//
//  BDLocalData.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-14.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDLocalData.h"
@implementation BDShengData
@end
@implementation BDCityData

@end

static BDLocalData * _localData = nil;
@implementation BDLocalData

+ (BDLocalData *) initWithDataPlist:(NSString *)plist
{
    if (!_localData) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:plist
                                                          ofType:@"plist"];
        NSDictionary * localDic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        if (plist &&
            path &&
            localDic &&
            [localDic isKindOfClass:[NSDictionary class]]) {
            
            _localData = [[BDLocalData alloc] init];
            NSArray * arr  = [localDic objectForKey:@"localData"];
            _localData.shengArr = [NSMutableArray arrayWithCapacity:[arr count]];
            for (NSDictionary * dic in arr) {
                BDShengData * shengData = [[BDShengData alloc] init];
                shengData.shengName = [dic objectForKey:@"shengname"];
                shengData.shengCode = [dic objectForKey:@"shengcode"];
                NSArray * cityArr = [dic objectForKey:@"cityarr"];
                shengData.cityArr = [NSMutableArray arrayWithCapacity:[cityArr count]];
                for (NSDictionary * cityDic in cityArr) {
                    BDCityData * cityData = [[BDCityData alloc] init];
                    cityData.cityName = [cityDic objectForKey:@"cityname"];
                    cityData.cityCode = [cityDic objectForKey:@"citycode"];
                    [shengData.cityArr addObject:cityData];
                }
                [_localData.shengArr addObject:shengData];
            }
            
        }

    }
    
    return _localData;
    
}

@end
