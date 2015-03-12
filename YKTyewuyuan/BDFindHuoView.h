//
//  BDFindHuoView.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-19.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDRequestData.h"
#import "BDCarInfo.h"

@class BDLocalData;
@protocol BDFindHuoViewDelegate<NSObject>
- (void)backToRespond;

@end

@interface BDFindHuoView : UIView<UITextFieldDelegate,
UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView  * _titleView;
    UIView * _contentView;
    UIButton    * cfshengButton;
    UIButton    * cfcityButton;
    UIButton    * dstshengButton;
    UIButton    * dstcityButton;
    UIButton    * car_type_huo;
    UITextField * _checkTime;
    NSInteger  _selectCFSheng;
    NSInteger   _selectCFCity;
    NSInteger  _selectDstSheng;
    NSInteger  _selectDstCity;
    carInType   _type;
    NSArray * _huoArr;
    UIView          * _pickerWithToolView;
    UIPickerView    * _pickerView;
    UIDatePicker    * _checkNianPicker;
    UIView          * _checkTimePickerView;
    NSInteger       _selecint ;
    BDLocalData     * _localData;
    NSInteger   _flag;
    NSString        *_huozhuPhone;
    
}
@property (nonatomic,strong)NSString * carPai;
@property (nonatomic,strong)UILabel *carPaiLabel;
@property (nonatomic,strong) id<BDFindHuoViewDelegate> adelegate;
@property (nonatomic,strong)     UITableView     * huoTableView;
@property (nonatomic,strong)NSMutableArray  *huoList;
@property (nonatomic,strong)UILabel * titileLabel2;

@end
