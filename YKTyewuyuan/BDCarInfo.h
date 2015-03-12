//
//  BDCarInfo.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-14.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BDCarInfoData (@"BDCarInfoData")
#define YIKATONG_SIJI  (@"YIKATONG_SIJI")
typedef enum
{
    car_null = 0,
    car_empty,
    car_finding,
    car_sending
  
    
}carInType;


@interface BDCarInfo : NSObject<NSCoding>

@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * iphoneNum;
@property (nonatomic,strong)NSString * idcard;
@property (nonatomic,strong)NSString * youka;
@property (nonatomic,strong)NSString * youkaid;
@property (nonatomic,strong)NSString * yikatong;
@property (nonatomic,strong)NSString * yikatongid;
@property (nonatomic,assign)NSInteger   guanggao;

@property (nonatomic,strong)NSString * carPai;
@property (nonatomic,strong)NSString * carType;
@property (nonatomic,strong)NSString * carInsideType;
@property (nonatomic,strong)NSString * sheng;
@property (nonatomic,strong)NSString * city;
@property (nonatomic,strong)NSString * longSize;
@property (nonatomic,strong)NSString * withSize;
@property (nonatomic,strong)NSString * heightSize;
@property (nonatomic,strong)NSString * awalySheng;
@property (nonatomic,strong)NSString * awalyCity;
@property (nonatomic,strong)NSString * weightSize;
@property (nonatomic,strong)NSString * volumeSize;
@property (nonatomic,strong)NSString * carDriveNum;
@property (nonatomic,strong)NSString * carCheckTime;
@property (nonatomic,assign)int  noUpdate;

@property (nonatomic,assign)carInType type;
@property (nonatomic,strong)NSMutableArray * picList;
@property (nonatomic,strong)NSString * picListFlag;


+ (NSString *) getPicName:(NSString * )carPai;
@end
