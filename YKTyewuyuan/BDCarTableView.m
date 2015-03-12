//
//  BDCarTableView.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDCarTableView.h"
#import "carTableViewCell.h"
#import "BDUploadCarInfo.h"
#import "Utility.h"
#import "BDlongGes.h"
#import "BDUserDB.h"

@interface BDCarTableView()<carTableViewCellDelegate,UIAlertViewDelegate>
{
    NSIndexPath * _selectIndexPath;
}

@end
@implementation BDCarTableView
@synthesize listCar = _listCar;

- (void)setListCar:(NSMutableArray *)listCar
{
    _listCar = listCar;
    [self.carTableView reloadData];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self createTableView];
    }
    return self;
}

- (void)createTableView
{
    self.carTableView = [[UITableView alloc] initWithFrame:self.bounds
                                                     style:UITableViewStylePlain];
    [self.carTableView setBackgroundColor:[UIColor clearColor]];
    [self.carTableView setDelegate:self];
    [self.carTableView setDataSource:self];
    [self.carTableView setRowHeight:81];
    [self.carTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:self.carTableView];
    
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listCar count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"cellStr";
    carTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellStr"];
    if (!cell) {
        cell = [[carTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellStr];
        
    }
    cell.adelegate =self;
    NSInteger row = indexPath.row;
    [cell configureData:[self.listCar objectAtIndex:row]];
    
    BDlongGes * longGes = [[BDlongGes alloc] initWithTarget:self
                                                     action:@selector(deleteCellData:)];
    longGes.indexPath = indexPath;
    [cell addGestureRecognizer:longGes];

    return cell;
}

- (void)deleteCellData:(BDlongGes *)longGes
{
    if (_selectIndexPath == longGes.indexPath) {
        return;
    }
    _selectIndexPath = longGes.indexPath;
    UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"删除信息"
                                                        message:@"删除该条车辆"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
    alerView.tag = 999;
    [alerView show];
    
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        //删除
        NSInteger row = _selectIndexPath.row;
        BDCarInfo * carInfo = [self.listCar objectAtIndex:row];
        BOOL ret =  [[BDUserDB shareInstance] deleteUserWithCarPai:carInfo.carPai];
        if (ret) {
            [self.listCar removeObject:carInfo];
        }
        [self.carTableView reloadData];
    }
    _selectIndexPath = nil;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //编辑车辆
    NSInteger row = indexPath.row;
    if (self.aadelegate && [self.aadelegate respondsToSelector:@selector(createAddCarView:)]) {
        [self.aadelegate createAddCarView:[self.listCar objectAtIndex:row]];
    }
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    
}


#pragma mark -- carTableViewCellDelegate
- (void) uploadInfo:(NSString *)carPai
{
 [BDUploadCarInfo uploadCarWithCarPai:carPai
                         OnCompletion:^(NSObject *data, NSString *str) {
                             [Utility showTipsViewWithText:str];
                             
                         } onError:^(MKNetworkOperation *completedOperation, NSString *error) {
                             [Utility showTipsViewWithText:@"上传失败"];
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
