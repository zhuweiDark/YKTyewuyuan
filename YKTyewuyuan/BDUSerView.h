//
//  BDUSerView.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    user_qian = 0,
    user_jifen,
    user_you
}userType;

@interface BDUSerView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    UIView * _titleView;
    UITableView * _mainTableView;
    UILabel * titleLabel;
}
@property (nonatomic,strong)NSMutableArray * listInfo;
@property (nonatomic,assign)userType type;

@end
