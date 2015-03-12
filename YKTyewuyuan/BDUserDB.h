//
//  BDUserDB.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-19.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDCarInfo.h"
//单例
@interface BDUserDB : NSObject

+ (id)shareInstance;

/**
 * @brief 创建数据库
 */
- (void) createDataBase;

/**
 * @brief 保存一条车辆记录
 *
 * @param user 需要保存的车辆数据
 */
- (void) saveUser:(BDCarInfo *) car;

/**
 * @brief 删除一条车辆数据
 *
 * @param carpai 需要删除的车辆的carpai
 */
- (BOOL) deleteUserWithCarPai:(NSString *) carPai;

/**
 * @brief 修改车辆的信息
 *
 * @param car 需要修改的车辆信息
 */
- (void) mergeWithCarInfo:(BDCarInfo *) car;


- (BDCarInfo *) findWithCarPai:(NSString * )carPai;

- (NSArray *) getAllCarList;

- (NSArray *) searchNeedUpdateCarList;


- (void) updateCar:(NSString *)carPai
          NoUpdate:(NSInteger)noUpdate;

- (void) updatePic:(NSString *)carPai
               pic:(NSMutableArray *)list;

- (void) updatePic:(NSString *)carPai
               pic:(NSMutableArray *)list
          flagList:(NSMutableArray *)listFlag;

- (void)updateCar:(NSString *)carPai
     sendingState:(carInType) cartype;

- (carInType)sendingStateWithCarPai:(NSString *)carPai;

- (int) carListCount ;
- (void)closeDb;

- (void) deleteAllData;

- (void) deleteLocalData:(NSArray *)needUpdateArr totailArr:(NSArray *)totoailArr;

@end
