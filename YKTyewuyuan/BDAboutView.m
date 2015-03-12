//
//  BDAboutView.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-18.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDAboutView.h"
#import "BDAboutTableViewCell.h"

@implementation BDAboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createTitleView];
        [self createMiddleView];
    }
    return self;
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
    [titleLabel setText:@"关于我们"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:27]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setContentMode:UIViewContentModeCenter];
    [_titleView addSubview:titleLabel];
    
    img = [UIImage imageNamed:@"btn_back2"];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 7, img.size.width, img.size.height)];
    [backButton setBackgroundImage:img
                          forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(backButton)
         forControlEvents:UIControlEventTouchUpInside];
    
    [_titleView addSubview:backButton];

    
    [self addSubview:_titleView];
    
    
}

- (void)backButton
{
    
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(updateCarInfoListData)]) {
        [self.adelegate updateCarInfoListData];
    }
    [self removeFromSuperview];
    
    
}


- (void)loginOut
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_OUT
                                                        object:nil];
    
}

- (UIView *) createLoginOutFooterView
{
    UIImage * img = [UIImage imageNamed:@"loginOut"];

    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, img.size.height + 80)];
    [footView setBackgroundColor:[UIColor clearColor]];
    
    NSInteger x = (CGRectGetWidth(self.frame) - img.size.width)/2;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(x, 40, img.size.width, img.size.height)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:img
                      forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(loginOut)
     forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    
    return footView;
}


- (UIView *) createTableviewHeaderView
{
    UIImage * img = [UIImage imageNamed:@"about_logo"];

    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40+img.size.height )];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    NSInteger x = (self.frame.size.width - img.size.width)/2;
    
    UIImageView  * imgview = [[UIImageView alloc] initWithFrame:CGRectMake(x, 20 , img.size.width, img.size.height)];
    [imgview setImage:img];
    
    [headerView addSubview:imgview];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headerView.frame) -1, CGRectGetWidth(self.frame), 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [headerView addSubview:lineView];

    
    return headerView;
}

- (void) createMiddleView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.frame.size.width, CGRectGetHeight(self.frame) - CGRectGetMaxY(_titleView.frame))];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [_tableView setTableHeaderView:[self createTableviewHeaderView]];
    [_tableView setTableFooterView:[self createLoginOutFooterView]];
    [_tableView setRowHeight:55];
    [self addSubview:_tableView];
    
    
}

#pragma mark ---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndex = @"about_cellIndex";
    BDAboutTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (!cell) {
        cell = [[BDAboutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cellIndex];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.leftIcon.image = [UIImage imageNamed:@"about_home"];
        cell.leftTitle.text = @"访问官网";
    }
    else if(row == 1) {
        cell.leftIcon.image = [UIImage imageNamed:@"about_tel"];
        cell.leftTitle.text = @"联系电话 ：4000-0898-56";
    }
    else if(row == 2){
        cell.leftIcon.image = [UIImage imageNamed:@"about_wx"];
        cell.leftTitle.text = @"关注微信 ：sijiykt";
    }
    else {
        NSLog(@"出现错误了");
    }
    
    return cell;
}

#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        NSString * usertext = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
        NSString * passwd  = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
        
        NSDate  * date = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyMMddHH"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        formatter.locale = locale;
        
        NSString * timeStr = [formatter stringFromDate:date];
        
        NSString * passwdStr = [NSString stringWithFormat:@"%@%@",passwd,timeStr];
        
        NSString * urlStr = [NSString stringWithFormat:@"http://www.sijiykt.com/index.shtml?method=applogin&UserName=%@&Key=%@",usertext,[passwdStr stringFromMD5] ];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    else if(row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000089856"]];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (alertView.cancelButtonIndex == buttonIndex) {
            
        }
        else {
           
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000089856"]];
 
        }
    }
    else if(alertView.tag == 1) {
        if (alertView.cancelButtonIndex == buttonIndex) {
            
        }
        else {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sijiykt.com"]];
            
        }

    }
    else {
        NSLog(@"错误");
    }
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
