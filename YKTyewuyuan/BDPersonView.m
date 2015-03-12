//
//  BDPersonView.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDPersonView.h"
#import "BDRequestData.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "BDUserDB.h"
#import "NSStringEX.h"

@implementation BDPersonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self createTitleView];
        [self createTableView];
    }
    return self;
}

- (UIView *)createTableViewheaderView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 70)];
    
    UIImage * img = [UIImage imageNamed:@"account_photo"];
    _personIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, img.size.width, img.size.height)];
    [_personIcon setBackgroundColor:[UIColor clearColor]];
    [_personIcon setImage:img];
    [headerView addSubview:_personIcon];
    
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:UserNameShow];
    _personName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_personIcon.frame) +5, _personIcon.frame.origin.y, 100, 20)];
    _personName.backgroundColor = [UIColor clearColor];
    [_personName setFont:[UIFont boldSystemFontOfSize:15]];
    [_personName setTextColor:[UIColor colorWithHexValue:0x353535]];
    [_personName setText:str];
    [headerView addSubview:_personName];
    
    BDUserDB * db = [BDUserDB shareInstance];
    
    int num = [db carListCount];
    
    _carNum = [[UILabel alloc] initWithFrame:CGRectMake(_personName.frame.origin.x, CGRectGetMaxY(_personName.frame) +5, 100, 18)];
    [_carNum setFont:[UIFont systemFontOfSize:17]];
    _carNum.backgroundColor = [UIColor clearColor];
    [_carNum setText:[NSString stringWithFormat:@"车辆：%d",num]];
    [headerView addSubview:_carNum];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame) -0.5, 320, 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [headerView addSubview:lineView];

    return headerView;
}

- (void)createTableView
{
    _persontableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_titleView.frame))
                                                    style:UITableViewStylePlain];
    [_persontableView setDelegate:self];
    [_persontableView setDataSource:self];
    [_persontableView setRowHeight:64];
    _persontableView.tableHeaderView = [self createTableViewheaderView];
    [_persontableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_persontableView];
    
}

- (void) createTitleView
{
    UIImage * img = [UIImage imageNamed:@"title"];

    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    _titleView.backgroundColor = [UIColor clearColor];
    UIImageView * titleImgView = [[UIImageView alloc] initWithFrame:_titleView.bounds];
    [titleImgView setImage:img];
    [titleImgView setUserInteractionEnabled:YES];
    
    [_titleView addSubview:titleImgView];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(_titleView.frame))];
    titleLabel.backgroundColor= [UIColor clearColor];
    [titleLabel setText:@"个人中心"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:27]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setContentMode:UIViewContentModeCenter];
    [_titleView addSubview:titleLabel];
    
    
    [self addSubview:_titleView];

    
}

#pragma mark -- UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndex = @"cellIndex";
    BDpersonCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (!cell) {
        cell = [[BDpersonCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIndex];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    cell.detailButton.hidden = NO;
    if (row == 0) {
        cell.leftLabel.text = @"账户余额 ：";
    }
    else if(row == 1) {
        cell.leftLabel.text = @"油卡余额 ：";
        cell.detailButton.hidden = YES;
        
    }
    else if(row == 2) {
        cell.leftLabel.text = @"我的积分 ：";
    }
    cell.seconderLabel.text = [self.usrList objectAtIndex:row];
    cell.adelegate = self;
    cell.detailButton.tag = row;
    
    return cell;
    
}

- (void)requestPersonData
{
    BDRequestData * request = [[BDRequestData alloc] init];
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
    NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"GetAccountInfo",@"Action",
                          username,@"UserName",
                          passwdStr,@"Key",
                          nil];
    __weak BDPersonView * Weak_self = self;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self.usrList removeAllObjects];
    
    [request loginDataAsync:@""
                             dic:dic onCompletion:^(NSObject *data, NSString *str) {
                                 NSLog(@"s55555tr ==%@",str);
                                 [MBProgressHUD hideAllHUDsForView:Weak_self animated:YES];
                                 
                                 NSArray * arr = [str componentsSeparatedByString:@"##"];
                                 if ([arr count] == 2) {
                                     NSString * subStr = [arr objectAtIndex:0];
                                     if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                                         //表示成功
                                         //发生页面跳转
                                         NSString * secondestr = [arr objectAtIndex:1];
                                         NSArray * arr = [secondestr componentsSeparatedByString:@"@@"];
                                         Weak_self.usrList = [[NSMutableArray alloc] initWithArray:arr];
                                         [Weak_self.persontableView reloadData];
                                         
                                     }
                                     else {
                                         //失败
                                         NSString * subStr2 = [arr objectAtIndex:1];
                                         [Utility showTipsViewWithText:subStr2];
                                     }
                                 }
                                 else {
                                     [Utility showTipsViewWithText:@"未知错误"];
                                 }
                                 
                             } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                                 [MBProgressHUD hideAllHUDsForView:Weak_self animated:YES];
                                 
                                 NSString * errorStr = [error localizedDescription];
                                 [Utility showTipsViewWithText:@"请求失败"];
                             }];

}

#pragma mark --BDpersonCellDelegate

- (void)requestData:(NSInteger)index
{
    BDRequestData * request = [[BDRequestData alloc] init];
    NSString * action = @"getAccountLogs";
    if (index == 2) {
        action = @"getJFLogs";
    }
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
    NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
    

    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:action,@"Action",
                          username,@"UserName",
                          passwdStr,@"Key",
                          @"0",@"LastID",nil];
    __weak BDPersonView * weak_self=  self;
    [request loginDataAsync:@""
                        dic:dic
               onCompletion:^(NSObject *data, NSString *str) {
                   NSArray * arr = [str componentsSeparatedByString:@"##"];
                   if ([arr count] == 2) {
                       NSString * subStr = [arr objectAtIndex:0];
                       if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                           NSString * secondeStr  = [arr objectAtIndex:1];
                           NSArray * arr = [secondeStr componentsSeparatedByString:@"&&"];
                           if (index == 0) {
                               
                               [weak_self.userView removeFromSuperview];
                               
                               if (!weak_self.userView ) {
                                   
                                   weak_self.userView =  [[BDUSerView alloc] initWithFrame:self.bounds];
                               }
                               weak_self.userView.type = user_qian;
                               weak_self.userView.listInfo = [NSMutableArray arrayWithArray:arr];
                               
                               [weak_self addSubview:_userView];
                           }
                           else if(index == 2) {
                               [weak_self.userView removeFromSuperview];
                               
                               if (!weak_self.userView ) {
                                   
                                   weak_self.userView =  [[BDUSerView alloc] initWithFrame:self.bounds];
                               }
                               weak_self.userView.type = user_jifen;
                               weak_self.userView.listInfo = [NSMutableArray arrayWithArray:arr];
                               
                               [weak_self addSubview:_userView];
                           }
                           else  {
                               NSLog(@"出错了");
                           }
                       }
                       
                       else {
                           //失败
                           NSString * subStr2 = [arr objectAtIndex:1];
                           [Utility showTipsViewWithText:subStr2];
                       }

                   }
                   else {
                       [Utility showTipsViewWithText:@"未知错误"];
                   }

               } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                 
                   NSString * errorStr = [error localizedDescription];
                   [Utility showTipsViewWithText:@"请求失败"];

               }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
