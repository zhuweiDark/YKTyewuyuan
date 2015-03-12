//
//  BDFindHuoView.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-19.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDFindHuoView.h"
#import "BDLocalData.h"
#import "BDUserDB.h"
#import "Utility.h"
#import "BDHuoTableViewCell.h"
#import "NSStringEX.h"
#import <QuartzCore/QuartzCore.h>
#define font_height (15)

@implementation BDFindHuoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor  = [UIColor whiteColor];
        [self initSearchCarView];
        [self createContentView];
        [self initDatePickerView];
        [self initPickerView];
    }
    return self;
}

- (void) createtableView
{
    [_contentView removeFromSuperview];
    _flag = 1;
    self.huoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.frame.size.width, self.frame.size.height - CGRectGetHeight(_titleView.frame))];
    [self.huoTableView setDelegate:self];
    [self.huoTableView setDataSource:self];
    [self.huoTableView setRowHeight:81];
    [self.huoTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:self.huoTableView];

}


#pragma mark ---UITableViewDataSource


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"搜索货源：%@-%@   共%d条",cfcityButton.titleLabel.text,dstcityButton.titleLabel.text ,[self.huoList count]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.huoList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndex = @"huo_cellIndex";

    BDHuoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (!cell) {
        cell = [[BDHuoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cellIndex];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    for (NSString * str in self.huoList) {
        NSArray * arr = [str componentsSeparatedByString:@"@@"];
        if ([arr count]  != 5) {
            continue;
        }
        cell.titleLabel.text = [arr objectAtIndex:1];
        cell.qianLabel.text = [arr objectAtIndex:2];
        cell.phoneLabel.text = [arr objectAtIndex:3];
        cell.timeLabel.text = [arr objectAtIndex:4];

    }
    
    return cell;
}

#pragma mark --UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.huoList count] > 0) {
        return 35;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDHuoTableViewCell * cell = (BDHuoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
   
    _huozhuPhone = cell.phoneLabel.text;
    NSString * str = [NSString stringWithFormat:@"货主电话:%@",_huozhuPhone];
    UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"联系货主"
                                                        message:str
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"立即呼叫", nil];
    alerView.tag = 1;
    [alerView show];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (alertView.cancelButtonIndex == buttonIndex) {
            
        }
        else {
            NSString * phone = [NSString stringWithFormat:@"tel://%@",_huozhuPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            
        }
    }
    else {
        NSLog(@"错误");
    }
}


- (void)createContentView
{
    _flag = 0;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), 320, self.frame.size.height - CGRectGetMaxY(_titleView.frame))];
    
    UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 66, 35)];
    phoneLabel.backgroundColor  = [UIColor clearColor];
    phoneLabel.textAlignment = UITextAlignmentCenter;
    phoneLabel.contentMode = UIViewContentModeCenter;
    [phoneLabel setFont:[UIFont systemFontOfSize:font_height]];
    
    phoneLabel.text = @"车牌号 ：";
    [_contentView addSubview:phoneLabel];
    
    self.carPaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame), 10, 120, 35)];
    [self.carPaiLabel setFont:[UIFont boldSystemFontOfSize:20]];

    self.carPaiLabel.backgroundColor  = [UIColor clearColor];
    self.carPaiLabel.textAlignment = NSTextAlignmentLeft;
    self.carPaiLabel.contentMode = UIViewContentModeCenter;
    [self.carPaiLabel setFont:[UIFont boldSystemFontOfSize:20]];

    [_contentView addSubview:self.carPaiLabel];

    UILabel * cfdi = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_carPaiLabel.frame) +5, 66, 35)];
    cfdi.backgroundColor  = [UIColor clearColor];
    cfdi.textAlignment = UITextAlignmentCenter;
    cfdi.contentMode = UIViewContentModeCenter;
    [cfdi setFont:[UIFont systemFontOfSize:font_height]];
    cfdi.text = @"出发地 ：";
    [_contentView addSubview:cfdi];
    
    
    UITextField * tmpTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cfdi.frame) +5,
                                                                               cfdi.frame.origin.y,
                                                                               100, 35)];
    tmpTextFiled.backgroundColor = [UIColor clearColor];
    [tmpTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    tmpTextFiled.enabled = NO;
    UIImage * img = [UIImage imageNamed:@"buttonArr"];
    NSInteger y  = (CGRectGetHeight(tmpTextFiled.frame) - img.size.height) /2;
    
    UIImageView * tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled.frame) - img.size.width - 5, y, img.size.width, img.size.height)];
    [tmpImg setImage:img];
    [tmpTextFiled addSubview:tmpImg];
    [_contentView addSubview:tmpTextFiled];
    
    
     _localData = [BDLocalData initWithDataPlist:@"BDLocal"];
    BDShengData  * shengData = [_localData.shengArr objectAtIndex:0];
    
    cfshengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cfshengButton setFrame:tmpTextFiled.frame];
    [cfshengButton setTitle:shengData.shengName
                  forState:UIControlStateNormal];
    [cfshengButton addTarget:self
                      action:@selector(clickPickerButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [cfshengButton setBackgroundColor:[UIColor clearColor]];
    [cfshengButton setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [cfshengButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];

    cfshengButton.tag  = 0;
    [_contentView addSubview:cfshengButton];
    
    
    tmpTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cfshengButton.frame) +5, cfshengButton.frame.origin.y, cfshengButton.frame.size.width, cfshengButton.frame.size.height)];
    tmpTextFiled.backgroundColor = [UIColor clearColor];
    [tmpTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    tmpTextFiled.enabled = NO;
    img = [UIImage imageNamed:@"buttonArr"];
    y  = (CGRectGetHeight(tmpTextFiled.frame) - img.size.height) /2;
    
    tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled.frame) - img.size.width - 5, y, img.size.width, img.size.height)];
    [tmpImg setImage:img];
    [tmpTextFiled addSubview:tmpImg];
    [_contentView addSubview:tmpTextFiled];

    
    BDCityData * cityData = [shengData.cityArr objectAtIndex:0];
    
    cfcityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cfcityButton setFrame:tmpTextFiled.frame];
    [cfcityButton setBackgroundColor:[UIColor clearColor]];
    [cfcityButton setTitle:cityData.cityName
                 forState:UIControlStateNormal];
    [cfcityButton addTarget:self
                     action:@selector(clickPickerButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [cfcityButton setTitleColor:[UIColor colorWithHexValue:0x333333]
                        forState:UIControlStateNormal];
    [cfcityButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];

    cfcityButton.tag = 0;
    [_contentView addSubview:cfcityButton];

    
    
    cfdi = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(cfcityButton.frame) +5, 66, 35)];
    cfdi.backgroundColor  = [UIColor clearColor];
    cfdi.textAlignment = UITextAlignmentCenter;
    cfdi.contentMode = UIViewContentModeCenter;
    [cfdi setFont:[UIFont systemFontOfSize:font_height]];
    cfdi.text = @"目的地 ：";
    [_contentView addSubview:cfdi];
    
    
    tmpTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cfdi.frame) +5,
                                                                 cfdi.frame.origin.y, cfshengButton.frame.size.width, cfshengButton.frame.size.height)];
    tmpTextFiled.backgroundColor = [UIColor clearColor];
    [tmpTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    tmpTextFiled.enabled = NO;
    img = [UIImage imageNamed:@"buttonArr"];
    y  = (CGRectGetHeight(tmpTextFiled.frame) - img.size.height) /2;
    
    tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled.frame) - img.size.width - 5, y, img.size.width, img.size.height)];
    [tmpImg setImage:img];
    [tmpTextFiled addSubview:tmpImg];
    [_contentView addSubview:tmpTextFiled];

    shengData = [_localData.shengArr objectAtIndex:0];
    
    dstshengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dstshengButton setFrame:tmpTextFiled.frame];
    [dstshengButton setTitle:shengData.shengName
                   forState:UIControlStateNormal];
    [dstshengButton addTarget:self
                       action:@selector(clickPickerButton:)
            forControlEvents:UIControlEventTouchUpInside];
    dstshengButton.tag = 1;
    [dstshengButton setBackgroundColor:[UIColor clearColor]];
    [dstshengButton setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [dstshengButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];

    [_contentView addSubview:dstshengButton];
    
    
    tmpTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dstshengButton.frame) +5, dstshengButton.frame.origin.y, dstshengButton.frame.size.width, dstshengButton.frame.size.height)];
    tmpTextFiled.backgroundColor = [UIColor clearColor];
    [tmpTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    tmpTextFiled.enabled = NO;
    img = [UIImage imageNamed:@"buttonArr"];
    y  = (CGRectGetHeight(tmpTextFiled.frame) - img.size.height) /2;
    
    tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled.frame) - img.size.width - 5, y, img.size.width, img.size.height)];
    [tmpImg setImage:img];
    [tmpTextFiled addSubview:tmpImg];
    [_contentView addSubview:tmpTextFiled];

    cityData = [shengData.cityArr objectAtIndex:0];
    
    dstcityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dstcityButton setFrame:tmpTextFiled.frame];
    [dstcityButton setBackgroundColor:[UIColor clearColor]];
    [dstcityButton setTitle:cityData.cityName
                  forState:UIControlStateNormal];
    [dstcityButton addTarget:self
                      action:@selector(clickPickerButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [dstcityButton setTitleColor:[UIColor colorWithHexValue:0x333333]
                         forState:UIControlStateNormal];
    [dstcityButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];

    dstcityButton.tag = 1;
    [_contentView addSubview:dstcityButton];
    
    UILabel * nimdk = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(dstcityButton.frame)+5, 66, 35)];
    nimdk.backgroundColor  = [UIColor clearColor];
    nimdk.textAlignment = NSTextAlignmentRight;
    nimdk.contentMode = UIViewContentModeCenter;
    [nimdk setFont:[UIFont systemFontOfSize:font_height]];
    nimdk.text = @"状态 ：";
    [_contentView addSubview:nimdk];
    
    car_type_huo = [UIButton buttonWithType:UIButtonTypeCustom];
    [car_type_huo setFrame:CGRectMake(CGRectGetMaxX(nimdk.frame) +9,
                                        nimdk.frame.origin.y,
                                        108, 35)];
    [car_type_huo addTarget:self
                     action:@selector(clickPickerButton:)
             forControlEvents:UIControlEventTouchUpInside];
    [car_type_huo setBackgroundColor:[UIColor clearColor]];
    [car_type_huo setTitleColor:[UIColor colorWithHexValue:0x333333]
                        forState:UIControlStateNormal];
    [car_type_huo.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    
    [car_type_huo.layer setMasksToBounds:YES];
    [car_type_huo.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [car_type_huo.layer setBorderWidth:0.5];   //边框宽度
    [car_type_huo.layer setBorderColor:[UIColor grayColor].CGColor];//边框颜色

    car_type_huo.tag = 2;
    [_contentView addSubview:car_type_huo];
 
    nimdk = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(car_type_huo.frame)+5, 66, 35)];
    nimdk.backgroundColor  = [UIColor clearColor];
    nimdk.textAlignment = NSTextAlignmentRight;
    nimdk.contentMode = UIViewContentModeCenter;
    [nimdk setFont:[UIFont systemFontOfSize:font_height]];
    nimdk.text = @"时间 ：";
    [_contentView addSubview:nimdk];

    
    UIButton * checkTimerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkTimerButton setBackgroundColor:[UIColor clearColor]];
    [checkTimerButton setFrame:CGRectMake(CGRectGetMaxX(nimdk.frame)+8, nimdk.frame.origin.y, 200, 45)];
    [checkTimerButton addTarget:self
                         action:@selector(showDatePickerView)
               forControlEvents:UIControlEventTouchUpInside];
    
    _checkTime =  [[UITextField alloc] initWithFrame:CGRectMake(0, 0,200, 45)];
    _checkTime.backgroundColor = [UIColor clearColor];
    _checkTime.delegate = self;
    [_checkTime setBorderStyle:UITextBorderStyleRoundedRect];
    _checkTime.returnKeyType = UIReturnKeyDone;
    [_checkTime setClearButtonMode:UITextFieldViewModeWhileEditing];
    _checkTime.enabled = NO;
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString * strDate = [formatter stringFromDate:date];
    [_checkTime setText:strDate];

    [checkTimerButton addSubview:_checkTime];
    
    [_contentView addSubview:checkTimerButton];

    
    UIImage * imgFind = [UIImage imageNamed:@"dispatch_btn_find"];
    UIButton * findHuo = [UIButton buttonWithType:UIButtonTypeCustom];
    NSInteger x = checkTimerButton.frame.origin.x;//(self.frame.size.width - imgFind.size.width)/2;
    [findHuo setBackgroundImage:imgFind
                       forState:UIControlStateNormal];
    [findHuo setFrame:CGRectMake(x, CGRectGetMaxY(checkTimerButton.frame)+20, imgFind.size.width, imgFind.size.height)];
    [findHuo addTarget:self
                action:@selector(findHuo)
      forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:findHuo];
    
    [self addSubview:_contentView];
    
}
- (void)findHuo
{
    BDUserDB * db = [BDUserDB shareInstance];
    
    [db updateCar:self.carPaiLabel.text
     sendingState:_type ];
    BDRequestData * request = [[BDRequestData alloc] init];
    
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
    NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
    
    BDShengData * sheng = [_localData.shengArr objectAtIndex:_selectCFSheng];
    BDCityData * cityData = [sheng.cityArr objectAtIndex:_selectCFCity];
    BDShengData * dstSheng = [_localData.shengArr objectAtIndex:_selectDstSheng];
    BDCityData * dstCity = [dstSheng.cityArr objectAtIndex:_selectDstCity];
    NSInteger index = _type - 1;
    if (index < 0) {
        index = 0;
    }
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"getGoods",@"Action",
                          username,@"UserName",
                          passwdStr,@"Key",
                          self.carPaiLabel.text,@"CarNum",
                          @"0",@"LastID",
                          sheng.shengCode,@"CFsheng",
                          cityData.cityCode,@"CFshi",
                          dstSheng.shengCode,@"MDsheng",
                          dstCity.cityCode,@"MDshi",
                          [NSString stringWithFormat:@"%d",index],@"Status",
                          _checkTime.text,@"Date",
                          nil];
    
    __weak BDFindHuoView * Weak_self = self;

    
    [request loginDataAsync:@""
                             dic:dic onCompletion:^(NSObject *data, NSString *str) {
                                 
                                 NSLog(@"s4444tr ==%@",str);
                                 NSArray * arr = [str componentsSeparatedByString:@"##"];
                                 if ([arr count] == 2) {
                                     NSString * subStr = [arr objectAtIndex:0];
                                     if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                                         //表示成功
                                         //发生页面跳转
                                         NSString * secodeStr = [arr objectAtIndex:1];
                                         NSArray * huoTmpList = [secodeStr componentsSeparatedByString:@"&&"];
                                         Weak_self.huoList = [[NSMutableArray alloc] initWithArray:huoTmpList];
                                         Weak_self.titileLabel2.text = [NSString stringWithFormat:@"%@找货",Weak_self.carPaiLabel.text];
                                         [Weak_self createtableView];
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
                                 
                             }
                         onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                             
                             NSString * errorStr = [error localizedDescription];
                             [Utility showTipsViewWithText:@"请求失败"];
                             
                         }];

}

- (void)showDatePickerView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    _checkTimePickerView.hidden = NO;
    
}

#pragma mark ----UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (2 == _selecint) {
        //车型
        return 1;
    }
    else if(1 == _selecint || 0 ==_selecint) {
        return 2;
    }
    
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (2 == _selecint) {
        //车型
        return [_huoArr count];
    }
    else if(_selecint == 0 || 1 == _selecint) {
        
        if (component == 0) {
            return [_localData.shengArr count];
        }
        else if(component == 1){
            NSInteger selectIndex = [pickerView selectedRowInComponent:0];
            if (selectIndex < 0) {
                selectIndex = 0;
                
            }
            BDShengData * shengData = [_localData.shengArr objectAtIndex:selectIndex];
            return [shengData.cityArr count];
        }
        
    }
    
    return 0;
}
#pragma mark -- UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (2 == _selecint) {
        //车型
        return self.frame.size.width ;
    }
    else if(0 ==_selecint || 1 ==_selecint) {
        
        return self.frame.size.width/2.0f;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (2 == _selecint ) {
        //车型
        return  [_huoArr objectAtIndex:row];
    }
    else if(0 == _selecint || 1 == _selecint) {
        
        if (component == 0) {
            BDShengData * shengData = [_localData.shengArr objectAtIndex:row];
            return shengData.shengName;
        }
        else if(component == 1) {
            NSInteger selectsheng = _selectCFSheng;
            if (1 == _selecint) {
                selectsheng = _selectDstSheng;
            }
            BDShengData * shengData = [_localData.shengArr objectAtIndex:selectsheng];
            BDCityData * cityData = [shengData.cityArr objectAtIndex:row];
            return cityData.cityName;
        }
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (2 == _selecint ) {
        //车型
        _type = row +1;
    }
    else if(0 == _selecint ) {
        
        if (component == 0) {
            _selectCFSheng = row;
            _selectCFCity = 0;

            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadComponent:1];
        }
        else if(component == 1) {
            _selectCFSheng = [pickerView selectedRowInComponent:0];
            _selectCFCity = row;
        }
    }
    else if( _selecint == 1) {
        
        if (component == 0) {
            _selectDstSheng = row;
            _selectDstCity = 0;

            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadComponent:1];
        }
        else if(component == 1) {
            _selectDstSheng = [pickerView selectedRowInComponent:0];
            _selectDstCity = row;
        }
        
    }
    
}

- (void)clickPickerButton:(UIButton *)button
{
    _selecint = button.tag;
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    _pickerWithToolView.hidden = NO;
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];

    
    BDShengData * shengData = [_localData.shengArr objectAtIndex:_selectCFSheng];
    [cfshengButton setTitle:shengData.shengName
                  forState:UIControlStateNormal];
    
    BDCityData * cityData = [shengData.cityArr objectAtIndex:_selectCFCity];
    [cfcityButton setTitle:cityData.cityName
                 forState:UIControlStateNormal];
    
    shengData = [_localData.shengArr objectAtIndex:_selectDstSheng];
    [dstshengButton setTitle:shengData.shengName
                 forState:UIControlStateNormal];
    
    cityData = [shengData.cityArr objectAtIndex:_selectDstCity];
    [dstcityButton setTitle:cityData.cityName
                forState:UIControlStateNormal];
    if ([button isEqual:car_type_huo]) {
        int index = _type -1;
        if (index < 0) {
            index = 0;
        }
        [_pickerView selectRow:index inComponent:0 animated:NO];

    }
    else if([button isEqual:cfshengButton] ||[button isEqual:cfcityButton]) {
        [_pickerView selectRow:_selectCFSheng inComponent:0 animated:NO];
        [_pickerView selectRow:_selectCFCity  inComponent:1 animated:NO];
        
    }
    else if([button isEqual:dstshengButton]|| [button isEqual:dstcityButton]) {
        [_pickerView selectRow:_selectDstSheng inComponent:0 animated:NO];
        [_pickerView selectRow:_selectDstCity  inComponent:1 animated:NO];
        
    }

    [_pickerView reloadAllComponents];
}

- (void)initPickerView
{
    _pickerWithToolView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 250 +CGRectGetMaxY(_titleView.frame) , self.frame.size.width, 250)];
    [_pickerWithToolView setBackgroundColor:[UIColor clearColor]];
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [toolbar setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(clickPickerView)];
    [toolbar setItems:[NSArray arrayWithObject:barItem]];
    [_pickerWithToolView addSubview:toolbar];
    
    UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(toolbar.frame), self.frame.size.width, CGRectGetHeight(_pickerWithToolView.frame) - CGRectGetHeight(toolbar.frame))];
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    
    [pickerView setShowsSelectionIndicator:YES];
    _pickerView = pickerView;
    [_pickerWithToolView addSubview:pickerView];
    
    [self addSubview:_pickerWithToolView];
    _pickerWithToolView.hidden  = YES;
}

- (void)clickDatePickerView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSDate * date = _checkNianPicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString * strDate = [formatter stringFromDate:date];
    [_checkTime setText:strDate];
    _checkTimePickerView.hidden = YES;
    
}

- (void)clickPickerView {
    _pickerWithToolView.hidden = YES;
    
    if (2 == _selecint) {
        //车型
        int index = _type -1;
        if (index < 0) {
            index = 0;
        }
        [car_type_huo setTitle:[_huoArr objectAtIndex:index]
                      forState:UIControlStateNormal];
    }
    else if(0 == _selecint) {
        BDShengData * shengData = [_localData.shengArr objectAtIndex:_selectCFSheng];
        [cfshengButton setTitle:shengData.shengName
                      forState:UIControlStateNormal];
        
        BDCityData * cityData = [shengData.cityArr objectAtIndex:_selectCFCity];
        [cfcityButton setTitle:cityData.cityName
                     forState:UIControlStateNormal];
        
    }
    else if(1 == _selecint) {
        BDShengData * shengData = [_localData.shengArr objectAtIndex:_selectDstSheng];
        [dstshengButton setTitle:shengData.shengName
                       forState:UIControlStateNormal];
        
        BDCityData * cityData = [shengData.cityArr objectAtIndex:_selectDstCity];
        [dstcityButton setTitle:cityData.cityName
                      forState:UIControlStateNormal];
        
    }
    
}

- (void) initDatePickerView
{
    _checkTimePickerView  = [[UIView alloc] initWithFrame:_pickerWithToolView.frame];
    _checkTimePickerView.backgroundColor = [UIColor clearColor];
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [toolbar setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(clickDatePickerView)];
    [toolbar setItems:[NSArray arrayWithObject:barItem]];
    [_checkTimePickerView addSubview:toolbar];
    
    UIDatePicker * datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(toolbar.frame), self.frame.size.width, CGRectGetHeight(_checkTimePickerView.frame) - CGRectGetHeight(toolbar.frame))];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [datePicker setMaximumDate:[NSDate date]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    datePicker.locale = locale;
    
    _checkNianPicker = datePicker;
    [_checkTimePickerView addSubview:datePicker];
    
    [self addSubview:_checkTimePickerView];
    _checkTimePickerView.hidden  = YES;
    
}


-(void)setCarPai:(NSString *)carPai
{
    _carPai = carPai;
    [self.carPaiLabel setText:_carPai];
    BDUserDB * userDB = [BDUserDB shareInstance];

    _type = [userDB sendingStateWithCarPai:_carPai];
    
    _huoArr = [NSArray arrayWithObjects:@"空载中",@"待货中",@"送货中", nil];
    NSInteger index = _type -1;
    if (index < 0) {
        index = 0;
    }
    [car_type_huo setTitle:[_huoArr objectAtIndex:index]
                  forState:UIControlStateNormal];
    

    
}
- (void)initSearchCarView
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
    [titleLabel setText:@"车辆调度"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:27]];

    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setContentMode:UIViewContentModeCenter];
    [_titleView addSubview:titleLabel];
    self.titileLabel2 = titleLabel;
    
    
    img = [UIImage imageNamed:@"btn_back"];
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
    if (_flag == 1) {
        [_huoTableView removeFromSuperview];
        _flag = 0;
        self.titileLabel2.text = @"车辆调度";
        [self addSubview:_contentView];
    }
    else
    {
        if (self.adelegate && [self.adelegate respondsToSelector:@selector(backToRespond)]) {
            [self.adelegate backToRespond];
        }
        [self removeFromSuperview];

        
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
