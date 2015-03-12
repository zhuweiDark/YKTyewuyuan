//
//  BDCarTableView.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addCarView.h"
@protocol BDCarTableViewDelegate<NSObject>

- (void)createAddCarView:(BDCarInfo *)carInfo;

- (void)findHuo:(NSString * )carPai;
@end
@interface BDCarTableView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * carTableView;
@property (nonatomic,strong)NSMutableArray * listCar;
@property (nonatomic,strong)addCarView  * addCar;
@property (nonatomic,weak)id<BDCarTableViewDelegate> aadelegate;
@end
