//
//  addCarView.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-15.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "addCarView.h"
#import "BDLocalData.h"
#import "MBProgressHUD.h"
#import "BDRequestData.h"
#import "Utility.h"
#import "BDCarInfo.h"
#import "BDAddPhotoView.h"
#import "BDUserDB.h"
#import "BDLeftImgScroll.h"
#import "NSStringEX.h"
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    type_null= -1,
    type_car = 0,
    type_box ,
    type_local ,
    type_alwayLocal
    
}typeForCar;
#define  font_height    (17)
#define font_height2    (15)

@interface addCarView()<UITextFieldDelegate,
                        UIPickerViewDataSource,
                        UIPickerViewDelegate,
                        BDLeftImgScrollDelegate,
                        BDAddPhotoViewDelegate>
{
    UIView * _titleView;
    UIButton    * _backButton;
    UIButton    * _saveButton;
    UIScrollView * _mainScrollView;
    BDLeftImgScroll * _leftTopScrllView;
    UIView       * _mainContentView;
    UITextField  * _carPaiNum;
    UIButton    * _checkPaiButton;
    UIButton    * _carType;
    UIButton    * _carBox;
    UIButton    * _shengButton;
    UIButton    * _cityButton;
    NSInteger    _selectShengIndex;
    NSInteger    _selectCityIndex;
    BDLocalData * _localData;
    UITextField * _longText;
    UITextField * _widthText;
    UITextField * _heightText;
    UIButton    * _alwaySheng;
    UIButton    * _alwayCity;
    NSInteger    _selectAlwaySheng;
    NSInteger    _selectAlwayCity;
    UITextField * _weightText;
    UITextField * _volumText;
    UITextField * _driveCarNum;
    UITextField * _checkCarTime;
    UIButton    * _doneButton;
    UIButton    * _addPhotoButton;
    typeForCar   _type;
    BDRequestData *_requestData;
    UIView          * _pickerWithToolView;
    UIPickerView    * _pickerView;
    NSArray         * _carTypeList;
    NSArray         * _boxTypeList;
    NSInteger _selectCarTypeIndex;
    NSInteger  _selectBoxTypeIndex;
    UIDatePicker    * _checkNianPicker;
    UIView          * _checkTimePickerView;
    UILabel         * _titleLabel;
    
    UITextField     * _nameText;
    UITextField     * _iphoneText;
    UITextField     * _idNumText;
    UITextField     * _youkaText;
    BOOL              _hasGuanggao;
    UISwitch        * _hasSwitch;
    
    NSString *      _userDbCarPai;
    
}
@property (nonatomic,strong)UITextField * carPaiNum;

@end

@implementation addCarView
@synthesize carPaiNum = _carPaiNum;
@synthesize adelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        _localData = [BDLocalData initWithDataPlist:@"BDLocal"];
        _carTypeList = [NSArray arrayWithObjects:@"标准集装箱",@"低栏车",@"平板车",@"高栏车",@"冷藏车",@"保温车",@"超宽车",@"罐式车",@"后挂车",@"小货车",@"挂车",@"面包车",@"商务车",@"小车",@"其他",@"救援车", nil];
        _boxTypeList = [NSArray arrayWithObjects:@"帆布侧面平铁皮厢体",@"帆布波纹型厢体",@"平顶波纹型厢体",@"平顶铁皮厢体",@"栏杆型厢体", nil];
        _type = type_null;
        _selectShengIndex = _selectCityIndex = _selectAlwaySheng = _selectAlwayCity = 0;
        _selectCarTypeIndex = _selectBoxTypeIndex = 0;
        [self initSearchCarView];
        [self createScrollView];
        [self initPickerView];
        [self initDatePickerView];
    }
    return self;
}

- (void)createScrollView
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), _titleView.frame.size.width, CGRectGetHeight(self.frame)- CGRectGetHeight(_titleView.frame))];
    [_mainScrollView setBackgroundColor:[UIColor clearColor]];
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    _mainScrollView.userInteractionEnabled = YES;
    
    _mainContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height)];
    [_mainContentView setBackgroundColor:[UIColor clearColor]];
    _mainContentView.userInteractionEnabled = YES;
    
    UILabel * idtifyNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 35)];
    [idtifyNum setText:@"车牌号 ："];
    idtifyNum.backgroundColor  = [UIColor clearColor];
    idtifyNum.textAlignment = NSTextAlignmentRight;
    idtifyNum.contentMode = UIViewContentModeCenter;
    [idtifyNum setTextColor:[UIColor colorWithHexValue:0x333333]];
    [idtifyNum setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:idtifyNum];

    _carPaiNum = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(idtifyNum.frame)+3, idtifyNum.frame.origin.y, 160, 35)];
    _carPaiNum.backgroundColor = [UIColor clearColor];
    _carPaiNum.delegate = self;
    [_carPaiNum setFont:[UIFont boldSystemFontOfSize:20]];
    [_carPaiNum setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_carPaiNum setBorderStyle:UITextBorderStyleRoundedRect];
    _carPaiNum.returnKeyType = UIReturnKeyNext;
    [_carPaiNum setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_carPaiNum];

    _checkPaiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkPaiButton setFrame:CGRectMake(CGRectGetMaxX(_carPaiNum.frame) + 10, _carPaiNum.frame.origin.y, 50, CGRectGetHeight(_carPaiNum.frame))];
    [_checkPaiButton setTitle:@"验证"
                     forState:UIControlStateNormal];
    [_checkPaiButton addTarget:self
                        action:@selector(checkPaiNum)
              forControlEvents:UIControlEventTouchUpInside];
    [_checkPaiButton.layer setMasksToBounds:YES];
    [_checkPaiButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_checkPaiButton.layer setBorderWidth:0.5];   //边框宽度
    [_checkPaiButton.layer setBorderColor:[UIColor grayColor].CGColor];//边框颜色
    [_checkPaiButton setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [_checkPaiButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];

    [_mainContentView addSubview:_checkPaiButton];
    
    
    UILabel * tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_carPaiNum.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [tmpLabel setText:@"会员姓名 ："];
    tmpLabel.backgroundColor  = [UIColor clearColor];
    tmpLabel.textAlignment = NSTextAlignmentRight;
    tmpLabel.contentMode = UIViewContentModeCenter;
    [tmpLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [tmpLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];
    
    [_mainContentView addSubview:tmpLabel];
    
    _nameText =  [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x, tmpLabel.frame.origin.y, 212, 35)];
    _nameText.backgroundColor = [UIColor clearColor];
    _nameText.delegate = self;
    [_nameText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_nameText setBorderStyle:UITextBorderStyleRoundedRect];
    _nameText.returnKeyType = UIReturnKeyNext;
    [_nameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_nameText];

    
    
    tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_nameText.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [tmpLabel setText:@"手机号码 ："];
    tmpLabel.backgroundColor  = [UIColor clearColor];
    tmpLabel.textAlignment = NSTextAlignmentRight;
    tmpLabel.contentMode = UIViewContentModeCenter;
    [tmpLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [tmpLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];
    
    [_mainContentView addSubview:tmpLabel];
    
    _iphoneText =  [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x, tmpLabel.frame.origin.y, 212, 35)];
    _iphoneText.backgroundColor = [UIColor clearColor];
    _iphoneText.delegate = self;
    [_iphoneText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_iphoneText setBorderStyle:UITextBorderStyleRoundedRect];
    _iphoneText.returnKeyType = UIReturnKeyNext;
    [_iphoneText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_iphoneText];

    
    
    tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_iphoneText.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [tmpLabel setText:@"身份证号 ："];
    tmpLabel.backgroundColor  = [UIColor clearColor];
    tmpLabel.textAlignment = NSTextAlignmentRight;
    tmpLabel.contentMode = UIViewContentModeCenter;
    [tmpLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [tmpLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];
    
    [_mainContentView addSubview:tmpLabel];
    
    _idNumText =  [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x, tmpLabel.frame.origin.y, 212, 35)];
    _idNumText.backgroundColor = [UIColor clearColor];
    _idNumText.delegate = self;
    [_idNumText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_idNumText setBorderStyle:UITextBorderStyleRoundedRect];
    _idNumText.returnKeyType = UIReturnKeyNext;
    [_idNumText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_idNumText];

    
    tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_idNumText.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [tmpLabel setText:@"加油卡 ："];
    tmpLabel.backgroundColor  = [UIColor clearColor];
    tmpLabel.textAlignment = NSTextAlignmentRight;
    tmpLabel.contentMode = UIViewContentModeCenter;
    [tmpLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [tmpLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];
    
    [_mainContentView addSubview:tmpLabel];
    
    _youkaText =  [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x, tmpLabel.frame.origin.y, 212, 35)];
    _youkaText.backgroundColor = [UIColor clearColor];
    _youkaText.delegate = self;
    [_youkaText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_youkaText setBorderStyle:UITextBorderStyleRoundedRect];
    _youkaText.returnKeyType = UIReturnKeyNext;
    [_youkaText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_youkaText];

    
    
    
    UILabel * carType = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_youkaText.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [carType setText:@"车型 ："];
    carType.backgroundColor  = [UIColor clearColor];
    carType.textAlignment = NSTextAlignmentRight;
    carType.contentMode = UIViewContentModeCenter;
    [carType setTextColor:[UIColor colorWithHexValue:0x333333]];
    [carType setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:carType];

    _carType = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_carType setTitle:[_carTypeList objectAtIndex:_selectCarTypeIndex] forState:UIControlStateNormal];
    _carType.backgroundColor = [UIColor clearColor];
    [_carType setFrame:CGRectMake(_carPaiNum.frame.origin.x, carType.frame.origin.y, 160, CGRectGetHeight(carType.frame))];
    [_carType addTarget:self
                 action:@selector(clickPickerButton:)
       forControlEvents:UIControlEventTouchUpInside];
    [_carType.layer setMasksToBounds:YES];
    [_carType.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_carType.layer setBorderWidth:0.5];   //边框宽度
    [_carType.layer setBorderColor:[UIColor grayColor].CGColor];//边框颜色
    [_carType setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [_carType.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];

    [_mainContentView addSubview:_carType];
    
    UILabel * boxType = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_carType.frame) +20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [boxType setText:@"箱型 ："];
    boxType.backgroundColor  = [UIColor clearColor];
    boxType.textAlignment = NSTextAlignmentRight;
    boxType.contentMode = UIViewContentModeCenter;
    [boxType setTextColor:[UIColor colorWithHexValue:0x333333]];
    [boxType setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:boxType];

    _carBox = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_carBox setTitle:[_boxTypeList objectAtIndex:_selectBoxTypeIndex] forState:UIControlStateNormal];
    [_carBox setFrame:CGRectMake(_carPaiNum.frame.origin.x, boxType.frame.origin.y, 200, CGRectGetHeight(carType.frame))];
    _carBox.backgroundColor = [UIColor clearColor];
    [_carBox addTarget:self
                action:@selector(clickPickerButton:)
       forControlEvents:UIControlEventTouchUpInside];
    [_carBox setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [_carBox.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];

    [_carBox.layer setMasksToBounds:YES];
    [_carBox.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_carBox.layer setBorderWidth:0.5];   //边框宽度
    [_carBox.layer setBorderColor:[UIColor grayColor].CGColor];//边框颜色

    [_mainContentView addSubview:_carBox];

    UILabel * sheng = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_carBox.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [sheng setText:@"所在地 ："];
    sheng.backgroundColor  = [UIColor clearColor];
    sheng.textAlignment = NSTextAlignmentRight;
    sheng.contentMode = UIViewContentModeCenter;
    [sheng setTextColor:[UIColor colorWithHexValue:0x333333]];
    [sheng setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:sheng];

    
    UITextField * tmpTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x,
                                                                               sheng.frame.origin.y,
                                                                               100, 35)];
    tmpTextFiled.backgroundColor = [UIColor clearColor];
    [tmpTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    tmpTextFiled.enabled = NO;
    UIImage * img = [UIImage imageNamed:@"buttonArr"];
    NSInteger y  = (CGRectGetHeight(tmpTextFiled.frame) - img.size.height) /2;
    
    UIImageView * tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled.frame) - img.size.width - 5, y, img.size.width, img.size.height)];
    [tmpImg setImage:img];
    [tmpTextFiled addSubview:tmpImg];
    [_mainContentView addSubview:tmpTextFiled];

    BDShengData  * shengData = [_localData.shengArr objectAtIndex:0];
    _shengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shengButton setFrame:tmpTextFiled.frame];
    [_shengButton setTitle:shengData.shengName
                  forState:UIControlStateNormal];
    [_shengButton addTarget:self
                     action:@selector(clickPickerButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [_shengButton setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [_shengButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [_shengButton setBackgroundColor:[UIColor clearColor]];

    [_mainContentView addSubview:_shengButton];
    
    
    
    tmpTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_shengButton.frame) +10, _shengButton.frame.origin.y, _shengButton.frame.size.width, _shengButton.frame.size.height)];
    tmpTextFiled.backgroundColor = [UIColor clearColor];
    [tmpTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    tmpTextFiled.enabled = NO;
     img = [UIImage imageNamed:@"buttonArr"];
     y  = (CGRectGetHeight(tmpTextFiled.frame) - img.size.height) /2;
    
    tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled.frame) - img.size.width - 5, y, img.size.width, img.size.height)];
    [tmpImg setImage:img];
    [tmpTextFiled addSubview:tmpImg];
    [_mainContentView addSubview:tmpTextFiled];

    BDCityData * cityData = [shengData.cityArr objectAtIndex:0];
    
    _cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cityButton setFrame:CGRectMake(CGRectGetMaxX(_shengButton.frame) +10, _shengButton.frame.origin.y, _shengButton.frame.size.width, _shengButton.frame.size.height)];
    [_cityButton setBackgroundColor:[UIColor clearColor]];
    [_cityButton setTitle:cityData.cityName
                 forState:UIControlStateNormal];
    [_cityButton addTarget:self
                    action:@selector(clickPickerButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [_cityButton setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [_cityButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [_mainContentView addSubview:_cityButton];
    
    UILabel * longLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_cityButton.frame)+20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [longLabel setText:@"长/宽/高 ："];
    longLabel.backgroundColor  = [UIColor clearColor];
    longLabel.textAlignment = NSTextAlignmentRight;
    longLabel.contentMode = UIViewContentModeCenter;
    [longLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [longLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:longLabel];

    _longText =  [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x, longLabel.frame.origin.y, 50, 35)];
    _longText.backgroundColor = [UIColor clearColor];
    _longText.delegate = self;
//    [_longText setPlaceholder:@"单位 ‘米‘"];
    [_longText setBorderStyle:UITextBorderStyleRoundedRect];
    _longText.returnKeyType = UIReturnKeyNext;
    [_longText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [_longText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_longText];
    
    UILabel * tmpLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_longText.frame)+5, _longText.frame.origin.y, 15, CGRectGetHeight(idtifyNum.frame))];
     [tmpLabel2 setText:@"米"];
     tmpLabel2.backgroundColor  = [UIColor clearColor];
     tmpLabel2.textAlignment = NSTextAlignmentRight;
     tmpLabel2.contentMode = UIViewContentModeCenter;
     [tmpLabel2 setTextColor:[UIColor colorWithHexValue:0x333333]];
     [tmpLabel2 setFont:[UIFont boldSystemFontOfSize:font_height2]];
 
     [_mainContentView addSubview:tmpLabel2];
    
//    UILabel * widthLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_longText.frame) +20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
//    [widthLabel setText:@"宽 ："];
//    widthLabel.backgroundColor  = [UIColor clearColor];
//    widthLabel.textAlignment = NSTextAlignmentRight;
//    widthLabel.contentMode = UIViewContentModeCenter;
//    [widthLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
//    [widthLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];

//    [_mainContentView addSubview:widthLabel];

    _widthText =  [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tmpLabel2.frame) +5, _longText.frame.origin.y, CGRectGetWidth(_longText.frame), CGRectGetHeight(_longText.frame))];
    _widthText.backgroundColor = [UIColor clearColor];
    _widthText.delegate = self;
//    [_widthText setPlaceholder:@"单位 ‘米‘"];
    [_widthText setBorderStyle:UITextBorderStyleRoundedRect];
    _widthText.returnKeyType = UIReturnKeyNext;
    [_widthText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_widthText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_widthText];
    
    tmpLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_widthText.frame) +5, _longText.frame.origin.y, 15, CGRectGetHeight(idtifyNum.frame))];
    [tmpLabel2 setText:@"米"];
    tmpLabel2.backgroundColor  = [UIColor clearColor];
    tmpLabel2.textAlignment = NSTextAlignmentRight;
    tmpLabel2.contentMode = UIViewContentModeCenter;
    [tmpLabel2 setTextColor:[UIColor colorWithHexValue:0x333333]];
    [tmpLabel2 setFont:[UIFont boldSystemFontOfSize:font_height2]];
    
    [_mainContentView addSubview:tmpLabel2];


//    UILabel * heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_widthText.frame) +20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
//    [heightLabel setText:@"高 ："];
//    heightLabel.backgroundColor  = [UIColor clearColor];
//    heightLabel.textAlignment = NSTextAlignmentRight;
//    
//    heightLabel.contentMode = UIViewContentModeCenter;
//    [heightLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
//    [heightLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];
//
//    [_mainContentView addSubview:heightLabel];
    
    _heightText =  [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tmpLabel2.frame) +5, _widthText.frame.origin.y, CGRectGetWidth(_longText.frame), CGRectGetHeight(_longText.frame))];
    _heightText.backgroundColor = [UIColor clearColor];
    _heightText.delegate = self;
    [_heightText setBorderStyle:UITextBorderStyleRoundedRect];
    _heightText.returnKeyType = UIReturnKeyNext;
    [_heightText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

//    [_heightText setPlaceholder:@"单位 ‘米‘"];
    [_heightText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_heightText];
    
    
    tmpLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_heightText.frame) +5, _longText.frame.origin.y, 15, CGRectGetHeight(idtifyNum.frame))];
    [tmpLabel2 setText:@"米"];
    tmpLabel2.backgroundColor  = [UIColor clearColor];
    tmpLabel2.textAlignment = NSTextAlignmentRight;
    tmpLabel2.contentMode = UIViewContentModeCenter;
    [tmpLabel2 setTextColor:[UIColor colorWithHexValue:0x333333]];
    [tmpLabel2 setFont:[UIFont boldSystemFontOfSize:font_height2]];
    
    [_mainContentView addSubview:tmpLabel2];

    
    UILabel * alwayLocal = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_heightText.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [alwayLocal setText:@"常驻地 ："];
    alwayLocal.backgroundColor  = [UIColor clearColor];
    alwayLocal.textAlignment = NSTextAlignmentRight;
    alwayLocal.contentMode = UIViewContentModeCenter;
    [alwayLocal setTextColor:[UIColor colorWithHexValue:0x333333]];
    [alwayLocal setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:alwayLocal];
    
    
    tmpTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x,
                                                                 alwayLocal.frame.origin.y, _shengButton.frame.size.width, _shengButton.frame.size.height)];
    tmpTextFiled.backgroundColor = [UIColor clearColor];
    [tmpTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    tmpTextFiled.enabled = NO;
    img = [UIImage imageNamed:@"buttonArr"];
    y  = (CGRectGetHeight(tmpTextFiled.frame) - img.size.height) /2;
    
    tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled.frame) - img.size.width - 5, y, img.size.width, img.size.height)];
    [tmpImg setImage:img];
    [tmpTextFiled addSubview:tmpImg];
    [_mainContentView addSubview:tmpTextFiled];
    

     shengData = [_localData.shengArr objectAtIndex:0];
    _alwaySheng = [UIButton buttonWithType:UIButtonTypeCustom];
    [_alwaySheng setFrame:tmpTextFiled.frame];
    [_alwaySheng setTitle:shengData.shengName
                  forState:UIControlStateNormal];
    [_alwaySheng addTarget:self
                    action:@selector(clickPickerButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [_alwaySheng setBackgroundColor:[UIColor clearColor]];
    [_alwaySheng setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [_alwaySheng.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    
    [_mainContentView addSubview:_alwaySheng];
    
    
    
    tmpTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_alwaySheng.frame) +10, _alwaySheng.frame.origin.y, _alwaySheng.frame.size.width, _alwaySheng.frame.size.height)];
    tmpTextFiled.backgroundColor = [UIColor clearColor];
    [tmpTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    tmpTextFiled.enabled = NO;
    img = [UIImage imageNamed:@"buttonArr"];
    y  = (CGRectGetHeight(tmpTextFiled.frame) - img.size.height) /2;
    
    tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled.frame) - img.size.width - 5, y, img.size.width, img.size.height)];
    [tmpImg setImage:img];
    [tmpTextFiled addSubview:tmpImg];
    [_mainContentView addSubview:tmpTextFiled];

    cityData = [shengData.cityArr objectAtIndex:0];
    
    _alwayCity = [UIButton buttonWithType:UIButtonTypeCustom];
    [_alwayCity setFrame:tmpTextFiled.frame];
    [_alwayCity setBackgroundColor:[UIColor clearColor]];
    [_alwayCity setTitle:cityData.cityName
                 forState:UIControlStateNormal];
    [_alwayCity addTarget:self
                   action:@selector(clickPickerButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [_alwayCity setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [_alwayCity.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [_mainContentView addSubview:_alwayCity];
    
    UILabel * weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_alwayCity.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [weightLabel setText:@"载重量 ："];
    weightLabel.backgroundColor  = [UIColor clearColor];
    weightLabel.textAlignment = NSTextAlignmentRight;
    weightLabel.contentMode = UIViewContentModeCenter;
    [weightLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [weightLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:weightLabel];

    _weightText =  [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x, weightLabel.frame.origin.y,212, 35)];
    _weightText.backgroundColor = [UIColor clearColor];
    _weightText.delegate = self;
    [_weightText setPlaceholder:@"单位 ‘吨‘"];
    [_weightText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_weightText setBorderStyle:UITextBorderStyleRoundedRect];
    _weightText.returnKeyType = UIReturnKeyNext;
    [_weightText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_weightText];

    UILabel * volumLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_weightText.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [volumLabel setText:@"容积 ："];
    volumLabel.backgroundColor  = [UIColor clearColor];
    volumLabel.textAlignment = NSTextAlignmentRight;
    volumLabel.contentMode = UIViewContentModeCenter;
    [volumLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [volumLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:volumLabel];
    
    _volumText =  [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x, volumLabel.frame.origin.y, CGRectGetWidth(_weightText.frame), CGRectGetHeight(_weightText.frame))];
    _volumText.backgroundColor = [UIColor clearColor];
    _volumText.delegate = self;
    [_volumText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_volumText setBorderStyle:UITextBorderStyleRoundedRect];
    _volumText.returnKeyType = UIReturnKeyNext;
    [_volumText setPlaceholder:@"单位 ‘方‘"];

    [_volumText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_volumText];

    UILabel * driveCarNum = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_volumText.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [driveCarNum setText:@"行驶证号 ："];
    driveCarNum.backgroundColor  = [UIColor clearColor];
    driveCarNum.textAlignment = NSTextAlignmentCenter;
    driveCarNum.contentMode = UIViewContentModeCenter;
    [driveCarNum setTextColor:[UIColor colorWithHexValue:0x333333]];
    [driveCarNum setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:driveCarNum];
    
    _driveCarNum =  [[UITextField alloc] initWithFrame:CGRectMake(_carPaiNum.frame.origin.x, driveCarNum.frame.origin.y, CGRectGetWidth(_weightText.frame), CGRectGetHeight(_weightText.frame))];
    _driveCarNum.backgroundColor = [UIColor clearColor];
    _driveCarNum.delegate = self;
    [_driveCarNum setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_driveCarNum setBorderStyle:UITextBorderStyleRoundedRect];
    _driveCarNum.returnKeyType = UIReturnKeyNext;
    [_driveCarNum setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainContentView addSubview:_driveCarNum];

    UILabel * checkTime = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_driveCarNum.frame) + 20, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [checkTime setText:@"年检时间 ："];
    checkTime.backgroundColor  = [UIColor clearColor];
    checkTime.textAlignment = NSTextAlignmentRight;
    checkTime.contentMode = UIViewContentModeCenter;
    [checkTime setTextColor:[UIColor colorWithHexValue:0x333333]];
    [checkTime setFont:[UIFont boldSystemFontOfSize:font_height2]];

    [_mainContentView addSubview:checkTime];
    
    UIButton * checkTimerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkTimerButton setBackgroundColor:[UIColor clearColor]];
    [checkTimerButton setFrame:CGRectMake(_carPaiNum.frame.origin.x, checkTime.frame.origin.y, CGRectGetWidth(_weightText.frame), CGRectGetHeight(_weightText.frame))];
    [checkTimerButton addTarget:self
                         action:@selector(showDatePickerView)
               forControlEvents:UIControlEventTouchUpInside];
    
    _checkCarTime =  [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_weightText.frame), CGRectGetHeight(_weightText.frame))];
    _checkCarTime.backgroundColor = [UIColor clearColor];
    _checkCarTime.delegate = self;
    [_checkCarTime setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_checkCarTime setBorderStyle:UITextBorderStyleRoundedRect];
    _checkCarTime.returnKeyType = UIReturnKeyDone;
    [_checkCarTime setClearButtonMode:UITextFieldViewModeWhileEditing];
    _checkCarTime.enabled = NO;
    [checkTimerButton addSubview:_checkCarTime];

    [_mainContentView addSubview:checkTimerButton];
    
    
    tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(checkTimerButton.frame) +10, CGRectGetWidth(idtifyNum.frame), CGRectGetHeight(idtifyNum.frame))];
    [tmpLabel setText:@"承载广告 ："];
    tmpLabel.backgroundColor  = [UIColor clearColor];
    tmpLabel.textAlignment = NSTextAlignmentRight;
    tmpLabel.contentMode = UIViewContentModeCenter;
    [tmpLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [tmpLabel setFont:[UIFont boldSystemFontOfSize:font_height2]];
    
    [_mainContentView addSubview:tmpLabel];

    _hasGuanggao = NO;
    _hasSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_driveCarNum.frame.origin.x, tmpLabel.frame.origin.y, CGRectGetWidth(_driveCarNum.frame), CGRectGetHeight(_driveCarNum.frame))];
    _hasSwitch.on = NO;
    [_hasSwitch addTarget:self
                   action:@selector(jieguanggao)
         forControlEvents:UIControlEventValueChanged];
    
//    _hasButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_hasButton setFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(checkTimerButton.frame) +10, 300, 40)];
//    [_hasButton setTitle:@"承载广告"
//                forState:UIControlStateNormal];
//    [_hasButton addTarget:self
//                    action:@selector(jieguanggao)
//          forControlEvents:UIControlEventTouchUpInside];
    [_mainContentView addSubview:_hasSwitch];
    
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    img = [UIImage imageNamed:@"addnewcar_btn_ok"];
    [_doneButton setFrame:CGRectMake(idtifyNum.frame.origin.x, CGRectGetMaxY(_hasSwitch.frame) +20, img.size.width, img.size.height)];
    [_doneButton setBackgroundImage:img
                           forState:UIControlStateNormal];
    [_doneButton addTarget:self
                    action:@selector(clickDoneButton)
          forControlEvents:UIControlEventTouchUpInside];
    [_mainContentView addSubview:_doneButton];
    
    _addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    img = [UIImage imageNamed:@"addnewcar_btn_gopic"];
    [_addPhotoButton setFrame:CGRectMake(CGRectGetMaxX(_doneButton.frame)+10, _doneButton.frame.origin.y, img.size.width, img.size.height)];
    [_addPhotoButton setBackgroundImage:img
                               forState:UIControlStateNormal];
    [_addPhotoButton addTarget:self
                        action:@selector(clickAddPhotoButton)
              forControlEvents:UIControlEventTouchUpInside];
    [_mainContentView addSubview:_addPhotoButton];
    
    
    [_mainScrollView setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(_addPhotoButton.frame) +240)];
    CGRect frame = _mainContentView.frame;
    frame.size.height = _mainScrollView.contentSize.height;
    _mainContentView.frame = frame;
    
    [_mainScrollView addSubview:_mainContentView];

    [self addSubview:_mainScrollView];
    
    
}

- (void)jieguanggao
{
    _hasGuanggao =! _hasGuanggao;
    _hasSwitch.on = _hasGuanggao;
    //换图片
}

- (void) setCarInfo:(BDCarInfo *)carInfo
{
    if(!_leftTopScrllView) {
        _leftTopScrllView = [[BDLeftImgScroll alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        [_leftTopScrllView setBackgroundColor:[UIColor clearColor]];
        [_mainScrollView addSubview:_leftTopScrllView];
    }
    _doneButton.hidden = YES;
    _addPhotoButton.hidden = YES;
    _leftTopScrllView.adelegate = self;
    _leftTopScrllView.carPai = carInfo.carPai;
    
    _userDbCarPai = carInfo.carPai;
    [_leftTopScrllView setFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
   
    [_mainScrollView setContentSize:CGSizeMake(self.frame.size.width,  CGRectGetMaxY(_addPhotoButton.frame) +20 +_mainContentView.frame.origin.y)];
   
    CGRect frame = _mainContentView.frame;
    frame.origin.y = CGRectGetMaxY(_leftTopScrllView.frame);
    frame.size.height = _mainScrollView.contentSize.height;
    _mainContentView.frame = frame;

    _hasGuanggao = _hasSwitch.on = carInfo.guanggao;

    [_nameText setText:carInfo.name];
    [_iphoneText setText:carInfo.iphoneNum];
    [_idNumText setText:carInfo.idcard];
    [_youkaText setText:carInfo.youka];
    [_titleLabel setText:carInfo.carPai];
    
    [_carPaiNum setText:carInfo.carPai];
    _selectCarTypeIndex = [_carTypeList indexOfObject:carInfo.carType];
    [_carType setTitle:carInfo.carType
              forState:UIControlStateNormal];
    
    _selectBoxTypeIndex = [_boxTypeList indexOfObject:carInfo.carInsideType];
    [_carBox setTitle:carInfo.carInsideType
             forState:UIControlStateNormal];
    for (int i = 0; i < [_localData.shengArr count]; i++) {
        BDShengData * shengData = [_localData.shengArr objectAtIndex:i];
        if ([shengData.shengCode isEqualToString:[carInfo sheng]]) {
            _selectShengIndex = i;
            [_shengButton setTitle:shengData.shengName
                          forState:UIControlStateNormal];
            for (int j = 0; j <[shengData.cityArr count]; j++) {
                BDCityData  * cityData = [shengData.cityArr objectAtIndex:j];
                if ([cityData.cityCode isEqualToString:carInfo.city]) {
                    _selectCityIndex = j;
                    [_cityButton setTitle:cityData.cityName
                                 forState:UIControlStateNormal];
                }
            }
        }
    }
    [_longText setText:carInfo.longSize];
    [_widthText setText:carInfo.withSize];
    [_heightText setText:carInfo.heightSize];

    for (int i = 0; i < [_localData.shengArr count]; i++) {
        BDShengData * shengData = [_localData.shengArr objectAtIndex:i];
        if ([shengData.shengCode isEqualToString:[carInfo awalySheng]]) {
            _selectAlwaySheng = i;
            [_alwaySheng setTitle:shengData.shengName
                         forState:UIControlStateNormal];
            for (int j = 0; j <[shengData.cityArr count]; j++) {
                BDCityData  * cityData = [shengData.cityArr objectAtIndex:j];
                if ([cityData.cityCode isEqualToString:carInfo.awalyCity]) {
                    _selectAlwayCity = j;
                    [_alwayCity setTitle:cityData.cityName
                                forState:UIControlStateNormal];
                }
            }
        }
    }
    [_weightText setText:carInfo.weightSize];
    [_volumText setText:carInfo.volumeSize];
    [_driveCarNum setText:carInfo.carDriveNum];
    [_checkCarTime setText:carInfo.carCheckTime];

}

- (void)clickDoneButton
{
    //检测数据合法性
    BOOL ret = [self checkDataInvaid];
    if (!ret) {
        [Utility showTipsViewWithText:@"请填写完整资料！"];
        return;
    }
    BDCarInfo * carInfo = [[BDCarInfo alloc] init];
    carInfo.carPai = _carPaiNum.text;
    carInfo.carType = _carType.titleLabel.text;
    carInfo.name = _nameText.text;
    carInfo.iphoneNum = _iphoneText.text;
    carInfo.idcard = _idNumText.text;
    carInfo.youka = _youkaText.text;
    carInfo.guanggao = _hasGuanggao;
    carInfo.carInsideType = _carBox.titleLabel.text;
    BDShengData * shengData = [_localData.shengArr objectAtIndex:_selectShengIndex];
    carInfo.sheng = shengData.shengCode;
    BDCityData * cityData = [shengData.cityArr objectAtIndex:_selectCityIndex];
    carInfo.city = cityData.cityCode;
    carInfo.longSize = _longText.text;
    carInfo.withSize = _widthText.text;
    carInfo.heightSize = _heightText.text;
    shengData = [_localData.shengArr objectAtIndex:_selectAlwaySheng];
    carInfo.awalySheng = shengData.shengCode;
    cityData = [shengData.cityArr objectAtIndex:_selectAlwayCity];
    carInfo.awalyCity = cityData.cityCode;
    carInfo.weightSize = _weightText.text;
    carInfo.volumeSize = _volumText.text;
    carInfo.carDriveNum = _driveCarNum.text;
    carInfo.carCheckTime = _checkCarTime.text;
    carInfo.noUpdate = 0;
    
    BDUserDB * userDb = [BDUserDB  shareInstance];
    if (![_userDbCarPai isEqualToString:carInfo.carPai]) {
        //说明修改了车牌号了。需要删除原来的记录
        [userDb deleteUserWithCarPai:_userDbCarPai];
    }
    BDCarInfo * tmp = [userDb findWithCarPai:carInfo.carPai];
    if (tmp) {
        //发生mergee
        [userDb mergeWithCarInfo:carInfo];
    }
    else
    {
        [userDb saveUser:carInfo];
    }
    
    [self backButton];
    return;
    
    
//    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:carInfo];
    
//    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:BDCarInfoData];
//    NSMutableDictionary * carInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//    [carInfoDic setObject:data
//                   forKey:carInfo.carPai];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:carInfoDic forKey:BDCarInfoData];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BDRequestData * request = [[BDRequestData alloc] init];
    
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
    NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
    
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    
    NSData * dataD = [carInfo.carType dataUsingEncoding:encode];

    
    NSString *carTypeTm = [[NSString alloc] initWithBytes:[dataD bytes]
                                               length:[dataD length]
                                             encoding:encode];
    
    NSString * carNum = [carInfo.carPai stringByReplacingOccurrencesOfString:@" "
                                                                  withString:@""];
    dataD = [carNum dataUsingEncoding:encode];
    carNum = [[NSString alloc] initWithBytes:[dataD bytes]
                                      length:[dataD length]
                                    encoding:encode];
    
    dataD = [carInfo.carInsideType dataUsingEncoding:encode];
    NSString * cartypeInside = [[NSString alloc] initWithBytes:[dataD bytes]
                                                        length:[dataD length]
                                                      encoding:encode];

    
    NSDictionary * dicReq = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"SyncCarInfo",@"Action",
                          username,@"UserName",
                          passwdStr,@"Key",
                          carNum,@"carnum",
                          carTypeTm,@"cartype",
                          cartypeInside,@"carbox",
                          carInfo.sheng,@"szsheng",
                          carInfo.city,@"szshi",
                          [NSString stringWithCString:[carInfo.longSize UTF8String] encoding:encode],@"chang",
                          [NSString stringWithCString:[carInfo.withSize UTF8String] encoding:encode],@"kuan",
                          [NSString stringWithCString:[carInfo.heightSize UTF8String] encoding:encode],@"gao",
                          carInfo.awalySheng,@"czsheng",
                          carInfo.awalyCity,@"czshi",
                          [NSString stringWithCString:[carInfo.weightSize UTF8String] encoding:encode],@"weight",
                          [NSString stringWithCString:[carInfo.volumeSize UTF8String] encoding:encode],@"volume",
                          [NSString stringWithCString:[carInfo.carDriveNum UTF8String] encoding:encode],@"volume",
                          carInfo.carCheckTime,@"cartestdate",
                          nil];
    
    [request loginDataAsync:@""
                             dic:dicReq onCompletion:^(NSObject *data, NSString *str) {
                                 
                                 NSLog(@"st99999r ==%@",str);
                                 NSArray * arr = [str componentsSeparatedByString:@"##"];
                                 if ([arr count] == 2) {
                                     NSString * subStr = [arr objectAtIndex:0];
                                     if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                                         //表示成功
                                         //发生页面跳转
                                         NSString * secodeStr = [arr objectAtIndex:1];
                                         
                                     }
                                     else {
                                         //失败
                                         NSString * subStr2 = [arr objectAtIndex:1];
                                         if ([[subStr2 lowercaseString] isEqualToString:@"delcar"]) {
                                             
                                         }
                                         [Utility showTipsViewWithText:subStr2];
                                     }
                                 }
                                 else {
                                     [Utility showTipsViewWithText:@"未知错误"];
                                 }
                                 [self backButton];

                                 
                             } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                                 
                                 NSString * errorStr = [error localizedDescription];
                                 [Utility showTipsViewWithText:@"请求失败"];
                                 [self backButton];

                             }];

}

- (void)clickAddPhotoButton
{
//    BOOL ret = [self checkDataInvaid];
    if ([_carPaiNum.text length] == 0) {
        [Utility showTipsViewWithText:@"请填写车牌号！"];
        return;
    }
    BDUserDB * userDb = [BDUserDB  shareInstance];
    BDCarInfo * carInfo = [[BDCarInfo alloc] init];
    carInfo.carPai = _carPaiNum.text;
    [userDb saveUser:carInfo];
    BDAddPhotoView * addPhoto = [[BDAddPhotoView alloc] initWithFrame:self.bounds];
    addPhoto.title = [_carPaiNum.text stringByReplacingOccurrencesOfString:@" "
                                                                withString:@""];
    addPhoto.adelegate = self;
    [self addSubview:addPhoto];
    
}
#pragma mark - BDAddPhotoViewDelegate

- (void)refreshPhoto
{
    if (_leftTopScrllView) {
        _leftTopScrllView.carPai = _carPaiNum.text;
    }
}

- (void)showDatePickerView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    CGPoint point = [_checkCarTime convertPoint:CGPointMake(CGRectGetMaxX(_checkCarTime.frame), CGRectGetMaxY(_checkCarTime.frame)) toView:_mainContentView];
    NSInteger yTop = self.frame.size.height - 250;
    NSInteger YOffset = point.y + _mainContentView.frame.origin.y ;
    if (YOffset > yTop) {
        [_mainScrollView setContentOffset:CGPointMake(0, YOffset -yTop + 30) ];
    }
    else {
        [_mainScrollView setContentOffset:CGPointMake(0, 0)];
        
    }

    _checkTimePickerView.hidden = NO;
    
}

- (void)clickDatePickerView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSDate * date = _checkNianPicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString * strDate = [formatter stringFromDate:date];
    [_checkCarTime setText:strDate];
    _checkTimePickerView.hidden = YES;
    
}

- (void)clickPickerView {
    _pickerWithToolView.hidden = YES;
    
    if (_type == type_car) {
        //车型
        [_carType setTitle:[_carTypeList objectAtIndex:_selectCarTypeIndex]
                  forState:UIControlStateNormal];
        [self clickPickerButton:_carBox];
    }
    else if(_type == type_box) {
        //箱型
        [_carBox setTitle:[_boxTypeList objectAtIndex:_selectBoxTypeIndex]
                 forState:UIControlStateNormal];
        [self clickPickerButton:_shengButton];
    }
    else if(_type == type_local) {
        BDShengData * shengData = [_localData.shengArr objectAtIndex:_selectShengIndex];
        [_shengButton setTitle:shengData.shengName
                      forState:UIControlStateNormal];
        
        BDCityData * cityData = [shengData.cityArr objectAtIndex:_selectCityIndex];
        [_cityButton setTitle:cityData.cityName
                     forState:UIControlStateNormal];
        _type = type_null;
        [_longText becomeFirstResponder];
        
    }
    else if(_type == type_alwayLocal) {
        BDShengData * shengData = [_localData.shengArr objectAtIndex:_selectAlwaySheng];
        [_alwaySheng setTitle:shengData.shengName
                      forState:UIControlStateNormal];
        
        BDCityData * cityData = [shengData.cityArr objectAtIndex:_selectAlwayCity];
        [_alwayCity setTitle:cityData.cityName
                     forState:UIControlStateNormal];
        _type = type_null;
        [_weightText becomeFirstResponder];

    }
    
}

- (void)clickPickerButton:(UIButton *)button
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    _pickerWithToolView.hidden = NO;
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];

    [_carType setTitle:[_carTypeList objectAtIndex:_selectCarTypeIndex]
              forState:UIControlStateNormal];
    [_carBox setTitle:[_boxTypeList objectAtIndex:_selectBoxTypeIndex]
             forState:UIControlStateNormal];
    BDShengData * shengData = [_localData.shengArr objectAtIndex:_selectShengIndex];
    [_shengButton setTitle:shengData.shengName
                  forState:UIControlStateNormal];
    
    BDCityData * cityData = [shengData.cityArr objectAtIndex:_selectCityIndex];
    [_cityButton setTitle:cityData.cityName
                 forState:UIControlStateNormal];
    
    shengData = [_localData.shengArr objectAtIndex:_selectAlwaySheng];
    [_alwaySheng setTitle:shengData.shengName
                 forState:UIControlStateNormal];
    
    cityData = [shengData.cityArr objectAtIndex:_selectAlwayCity];
    [_alwayCity setTitle:cityData.cityName
                forState:UIControlStateNormal];

    if ([button isEqual:_carType]) {
        _type = type_car;
        [_pickerView selectRow:_selectCarTypeIndex inComponent:0 animated:NO];

    }
    else if([button isEqual:_carBox]) {
        _type = type_box;
        [_pickerView selectRow:_selectBoxTypeIndex inComponent:0 animated:NO];

    }
    else if([button isEqual:_shengButton] ||[button isEqual:_cityButton]) {
        _type = type_local;
        [_pickerView selectRow:_selectShengIndex inComponent:0 animated:NO];
        [_pickerView selectRow:_selectCityIndex  inComponent:1 animated:NO];

    }
    else if([button isEqual:_alwaySheng]|| [button isEqual:_alwayCity]) {
        _type = type_alwayLocal;
        [_pickerView selectRow:_selectAlwaySheng inComponent:0 animated:NO];
        [_pickerView selectRow:_selectAlwayCity  inComponent:1 animated:NO];

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
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [_pickerWithToolView addSubview:pickerView];
    
    [self addSubview:_pickerWithToolView];
    _pickerWithToolView.hidden  = YES;
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


#pragma mark ----UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_type == type_car) {
        //车型
        return 1;
    }
    else if(_type == type_box) {
        //箱型
        return 1;
    }
    else if(_type == type_local) {
        return 2;
    }
    else if(_type == type_alwayLocal) {
        return 2;
    }

    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_type == type_car) {
        //车型
        return [_carTypeList count];
    }
    else if(_type == type_box) {
        //箱型
        return [_boxTypeList count];
    }
    else if(_type == type_local || _type == type_alwayLocal) {
        
        if (component == 0) {
            return [_localData.shengArr count];
        }
        else if(component == 1){
            NSInteger selectsheng = _selectShengIndex;
            if (_type == type_alwayLocal) {
                selectsheng = _selectAlwaySheng;
            }
            BDShengData * shengData = [_localData.shengArr objectAtIndex:selectsheng];
            return [shengData.cityArr count];
        }

    }

    return 0;
}
#pragma mark -- UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (_type == type_car || _type == type_box) {
        //车型
        return self.frame.size.width ;
    }
    else if(_type == type_local || _type == type_alwayLocal) {
        
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
    if (_type == type_car ) {
        //车型
        return  [_carTypeList objectAtIndex:row];
    }
    else if( _type == type_box ) {
        return [_boxTypeList objectAtIndex:row] ;
    }
    else if(_type == type_local || _type == type_alwayLocal) {
        
        if (component == 0) {
            BDShengData * shengData = [_localData.shengArr objectAtIndex:row];
            return shengData.shengName;
        }
        else if(component == 1) {
            NSInteger ColoumRow = [pickerView selectedRowInComponent:0];
            BDShengData * shengData = [_localData.shengArr objectAtIndex:ColoumRow];
            BDCityData * cityData = [shengData.cityArr objectAtIndex:row];
            return cityData.cityName;
        }
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (_type == type_car ) {
        //车型
        _selectCarTypeIndex = row;
    }
    else if( _type == type_box ) {
        _selectBoxTypeIndex = row;
    }
    else if(_type == type_local ) {
        
        if (component == 0) {
            _selectShengIndex = row;
            _selectCityIndex = 0;

            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadComponent:1];
        }
        else if(component == 1) {
            _selectShengIndex = [pickerView selectedRowInComponent:0];
            _selectCityIndex = row;
        }
    }
    else if( _type == type_alwayLocal) {
        if (component == 0) {
            _selectAlwaySheng = row;
            _selectAlwayCity = 0;

            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadComponent:1];
        }
        else if(component == 1) {
            _selectAlwaySheng = [pickerView selectedRowInComponent:0];
            _selectAlwayCity = row;
        }

    }

}

- (void)checkPaiNum
{
    if ([_carPaiNum.text length] == 0) {
        [Utility showTipsViewWithText:@"请输入车牌号码！"];
        return;
    }
    [_carPaiNum resignFirstResponder];
    [_requestData cancel];
    
    _requestData = [[BDRequestData alloc] init];
    
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
    NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData * dataD = [_carPaiNum.text dataUsingEncoding:encode];
    
    NSString *carPaiNum = [[NSString alloc] initWithBytes:[dataD bytes]
                                               length:[dataD length]
                                             encoding:encode];
 
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"TestCarNum",@"Action",
                          username,@"UserName",
                          passwdStr,@"Key",
                          carPaiNum,@"CarNum",
                          nil];
    
    __weak addCarView * Weak_self = self;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [_requestData loginDataAsync:@""
                             dic:dic onCompletion:^(NSObject *data, NSString *str) {
                                 
                                 [MBProgressHUD hideAllHUDsForView:Weak_self animated:YES];
                                 NSLog(@"s1000000tr ==%@",str);
                                 NSArray * arr = [str componentsSeparatedByString:@"##"];
                                 if ([arr count] == 2) {
                                     
                                     NSString * secodeStr = [arr objectAtIndex:1];
                                     [Utility showTipsViewWithText:secodeStr
                                                            inView:Weak_self];

                                 }
                                 else {
                                     [Utility showTipsViewWithText:@"未知错误"
                                                            inView:Weak_self];

                                 }
                                 
                             } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                                 [MBProgressHUD hideAllHUDsForView:Weak_self animated:YES];
                                 
                                 NSString * errorStr = [error localizedDescription];
                                 [Utility showTipsViewWithText:@"请求失败"
                                                        inView:Weak_self];

                             }];

    
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
    [titleLabel setText:@"新增车辆"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:27]];

    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setContentMode:UIViewContentModeCenter];
    [_titleView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    img = [UIImage imageNamed:@"btn_back2"];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 7, img.size.width, img.size.height)];
    [backButton setBackgroundImage:img
                         forState:UIControlStateNormal];
    [backButton addTarget:self
                  action:@selector(backButton)
        forControlEvents:UIControlEventTouchUpInside];
    
    [_titleView addSubview:backButton];
    
    
    img = [UIImage imageNamed:@"btn_save"];
    NSInteger x = self.frame.size.width - img.size.width - 10;
    UIButton * saveButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(x, 7, img.size.width, img.size.height)];
    [saveButton setBackgroundImage:img
                         forState:UIControlStateNormal];
    [saveButton addTarget:self
                  action:@selector(clickDoneButton)
        forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:saveButton];
    
    [self addSubview:_titleView];
    
}


- (void)backButton
{
    
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(updateCarInfoListData)]) {
        [self.adelegate updateCarInfoListData];
    }
    [self removeFromSuperview];
    
    
}

- (BOOL)checkDataInvaid
{
    BOOL ret = YES;
    
    if ([_carPaiNum.text length] == 0 ||
        [_longText.text length] == 0 ||
        [_widthText.text length] == 0 ||
        [_heightText.text length] == 0 ||
        [_weightText.text length] == 0 ||
        [_volumText.text length] == 0 ||
        [_nameText.text length] == 0 ||
        [_iphoneText.text  length] == 0 ) {
        ret = NO;
    }
    
    return ret;
}
#pragma mark -- UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger yTop = self.frame.size.height - 250;
    NSInteger YOffset = CGRectGetMaxY(textField.frame) + _mainContentView.frame.origin.y +CGRectGetMaxY(_titleView.frame) ;
    if (YOffset > yTop) {
        [_mainScrollView setContentOffset:CGPointMake(0, YOffset -yTop + 30) ];
    }
    else {
        [_mainScrollView setContentOffset:CGPointMake(0, 0)];

    }
    _checkTimePickerView.hidden = YES;
    _pickerWithToolView.hidden = YES;
    if ([textField isEqual:_checkCarTime]) {
        [_checkCarTime resignFirstResponder];
        _checkTimePickerView.hidden = NO;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_carPaiNum]) {
        [_carPaiNum resignFirstResponder];
        [_nameText becomeFirstResponder];
    }
    else if([textField isEqual:_nameText]) {
        [_nameText resignFirstResponder];
        [_iphoneText becomeFirstResponder];
    }
    else if([textField isEqual:_iphoneText]) {
        [_iphoneText resignFirstResponder];
        [_idNumText becomeFirstResponder];
    }
    else if([textField isEqual:_idNumText]) {
        [_idNumText resignFirstResponder];
        [_youkaText becomeFirstResponder];
    }
    else if([textField isEqual:_youkaText]) {
        [_youkaText resignFirstResponder];
        [self clickPickerButton:_carType];
    }
    else if([textField isEqual:_longText]) {
        [_longText resignFirstResponder];
        [_widthText becomeFirstResponder];
    }
    else if([textField isEqual:_widthText]) {
        [_widthText resignFirstResponder];
        [_heightText becomeFirstResponder];
    }
    else if([textField isEqual:_heightText]) {
        [_heightText resignFirstResponder];
        [self clickPickerButton:_alwaySheng];
    }
    else if([textField isEqual:_weightText]) {
        [_weightText resignFirstResponder];
        [_volumText becomeFirstResponder];
    }
    else if([_volumText isEqual:textField]) {
        [_volumText resignFirstResponder];
        [_driveCarNum becomeFirstResponder];
    }
    else if([_driveCarNum isEqual:textField]) {
        [_driveCarNum resignFirstResponder];
        _checkTimePickerView.hidden = NO;
    }
    else if([_checkCarTime isEqual:textField]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        _checkTimePickerView.hidden = NO;
    }
    return YES;
}
#pragma mark ---- BDLeftImgScrollDelegate

- (void)clickAddPohoto
{
    [self clickAddPhotoButton];
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
