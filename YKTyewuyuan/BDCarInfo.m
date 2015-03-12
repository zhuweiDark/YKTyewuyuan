//
//  BDCarInfo.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-14.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDCarInfo.h"
#import "BDLocalData.h"

@implementation BDCarInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.carPai forKey:@"carPai"];
    [aCoder encodeObject:self.carType forKey:@"carType"];
    [aCoder encodeObject:self.carInsideType forKey:@"carInsideType"];
    [aCoder encodeObject:self.sheng forKey:@"sheng"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.longSize forKey:@"longSize"];
    [aCoder encodeObject:self.withSize forKey:@"withSize"];
    [aCoder encodeObject:self.heightSize forKey:@"heightSize"];
    
    [aCoder encodeObject:self.awalySheng forKey:@"awalySheng"];
    [aCoder encodeObject:self.awalyCity forKey:@"awalyCity"];
    [aCoder encodeObject:self.weightSize forKey:@"weightSize"];
    [aCoder encodeObject:self.volumeSize forKey:@"volumeSize"];
    [aCoder encodeObject:self.carDriveNum forKey:@"carDriveNum"];
   // [aCoder encodeObject:self.noUpdate forKey:@"noUpdate"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.carPai = [aDecoder decodeObjectForKey:@"carPai"];
        self.carType = [aDecoder decodeObjectForKey:@"carType"];
        self.carInsideType = [aDecoder decodeObjectForKey:@"carInsideType"];
        self.sheng = [aDecoder decodeObjectForKey:@"sheng"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.longSize = [aDecoder decodeObjectForKey:@"longSize"];
        self.withSize = [aDecoder decodeObjectForKey:@"withSize"];
        self.heightSize = [aDecoder decodeObjectForKey:@"heightSize"];
        self.awalySheng = [aDecoder decodeObjectForKey:@"awalySheng"];
        self.awalyCity = [aDecoder decodeObjectForKey:@"awalyCity"];
        self.weightSize = [aDecoder decodeObjectForKey:@"weightSize"];
        self.volumeSize = [aDecoder decodeObjectForKey:@"volumeSize"];
        self.carDriveNum = [aDecoder decodeObjectForKey:@"carDriveNum"];
      //  self.noUpdate = [aDecoder decodeObjectForKey:@"noUpdate"];
    }
    return self;

    
}
- (NSString *)carPai
{
    if (!_carPai ||[_carPai length] == 0) {
        NSAssert(false, @"The carPai is NULL .");
    }
    return _carPai;
}

- (carInType) type
{
    if (_type == car_null) {
        _type = car_empty;
    }
    return _type;
}

- (NSString *)city
{
    if ([_city integerValue] == 0) {
        BDLocalData  * localData = [BDLocalData initWithDataPlist:@"BDLocal"];
        for (BDShengData * sheng in localData.shengArr) {
            if ([sheng.shengCode isEqualToString:self.sheng]) {
                NSAssert([sheng.cityArr count] > 0, @"城市数据有问题");
                BDCityData *city = [sheng.cityArr objectAtIndex:0];
                _city = city.cityCode;
            }
        }
    }
    NSAssert(![_city isEqualToString:@"0"], @"城市数据有问题");

    return _city;
}

+ (NSString *) getPicName:(NSString * )carPai
{
    NSString * strname = [[NSUserDefaults standardUserDefaults] objectForKey:@"USerNameTxt"];
    NSString * carpaiNum = carPai;
    NSDate  * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd_HHmmss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    formatter.locale = locale;

    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString * strDate = [formatter stringFromDate:date];
    NSString * picName = [NSString stringWithFormat:@"%@_%@_%@.jpg",strname,carpaiNum,strDate];
    return picName;
}

@end
