//
//  QianTableViewCell.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QianTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * qianLabel;

@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * changeLabel;

@property (nonatomic,strong)NSString * cellId;
@end
