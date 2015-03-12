//
//  addCarView.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-15.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol addCarViewDelegate <NSObject>

- (void) updateCarInfoListData;

@end

@class  BDCarInfo;
@interface addCarView : UIView

@property (nonatomic,weak)id<addCarViewDelegate>adelegate;

- (void) setCarInfo:(BDCarInfo *)carInfo;

@end
