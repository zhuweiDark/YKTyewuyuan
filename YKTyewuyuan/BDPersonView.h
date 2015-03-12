//
//  BDPersonView.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDpersonCell.h"
#import "BDUSerView.h"


@interface BDPersonView : UIView<UITableViewDataSource,UITableViewDelegate,BDpersonCellDelegate> {
   
    UIView  * _titleView;
    UIImageView * _personIcon;
    UILabel * _personName;
    UILabel * _carNum;
    
    UITableView * _persontableView;
    NSMutableArray * _usrList;
    BDUSerView * _userView;
}
@property (nonatomic,strong)NSMutableArray *usrList;
@property (nonatomic,strong)UITableView * persontableView;
@property (nonatomic,strong)BDUSerView * userView;
- (void)requestPersonData;

@end
