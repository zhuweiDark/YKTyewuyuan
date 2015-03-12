//
//  BDAboutView.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-18.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDRequestData.h"
#import "Utility.h"
#import "BDPersonCtr.h"
#import "BDRegisterCtr.h"
#import "NSString+MD5Addition.h"
#import "MBProgressHUD.h"


#define LOGIN_OUT       (@"LOGIN_OUT")

@protocol BDAboutViewDelegate <NSObject>

- (void) updateCarInfoListData;

@end

@interface BDAboutView : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIView  * _titleView;
    UITableView * _tableView;
}
@property (nonatomic,weak)id<BDAboutViewDelegate> adelegate;
@end
