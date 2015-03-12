//
//  BDRegisterCtr.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-12.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDRegisterCtr.h"
#import "BDLocalData.h"
#import "Utility.h"
#import "BDRequestData.h"
#import "NSString+MD5Addition.h"
#import "MBProgressHUD.h"
#import "NSStringEX.h"
#import "commData.h"

@interface BDRegisterCtr ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    
    UIScrollView    * _registerScrollView;
    UITextField     * _phoneNumText;
    UITextField     * _paswdText;
    UITextField     * _passwdAgainText;
    UITextField     * _userNameText;
    UIButton        * _shengButton;
    UIButton        * _cityButton;
    UIView          * _pickerWithToolView;
    UITextField     * _recommendPhoneNumText;
    
    UIButton        * _registerButton;
    BDLocalData     * _localData;
    UIPickerView    * _pickerView;
    NSInteger        _selectShengIndex;
    NSInteger        _selectCityIndex;
    BDRequestData   *  _requestData;
    UIView          * _successView;
}

@end

@implementation BDRegisterCtr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSInteger ytop = 0;
#ifdef IOS7_SDK_AVAILABLE
    if(IOS7_AVAILABLE){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        ytop = 20;
    }
#endif

    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ytop +44, self.view.frame.size.width, self.view.frame.size.height - ytop -44)];
    [backView setImage:[UIImage imageNamed:@"backgroup"]];
    [self.view addSubview:backView];

    self.navigationController.navigationBarHidden = YES;
    [self initSearchCarView];
    [self initRegisterView];
}

- (void)initSearchCarView
{
    NSInteger ytop = 0;
#ifdef IOS7_SDK_AVAILABLE
    if(IOS7_AVAILABLE){
        ytop = 20;
    }
#endif

    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ytop, self.view.frame.size.width, 44)];
    [imgView setImage:[UIImage imageNamed:@"title"]];
    imgView.backgroundColor = [UIColor blackColor];
    imgView.userInteractionEnabled = YES;
    
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(imgView.frame))];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:27]];
    [label setText:@"注册"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [imgView addSubview:label];
    
    UIImage * img = [UIImage imageNamed:@"btn_back"];

    UIImageView * imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, img.size.width, img.size.height)];
    [imgView2 setUserInteractionEnabled:YES];
    [imgView2 setImage:img];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(backToLogin)];
    [imgView2 addGestureRecognizer:tap];
    [imgView addSubview:imgView2];
    [self.view addSubview:imgView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) backToLogin
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void) showRegisterSuccessView
{
    _registerScrollView.hidden = YES;
    _successView = [[UIView alloc] initWithFrame:_registerScrollView.frame];
    [_successView setBackgroundColor:[UIColor clearColor]];
    
    UIImage * img = [UIImage imageNamed:@"login_title"];
    UIImageView * loginTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(53, 76, img.size.width, img.size.height)];
    loginTitleView.backgroundColor = [UIColor clearColor];
    [loginTitleView setImage:img];
    [_successView addSubview:loginTitleView];
    
    
    UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginTitleView.frame) +87, self.view.frame.size.width, 40)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [labelTitle setText:@"您已注册成功！"];
    [labelTitle setFont:[UIFont boldSystemFontOfSize:23]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setContentMode:UIViewContentModeCenter];
    [_successView addSubview:labelTitle];
    
    img = [UIImage imageNamed:@"registerok_login"];
    int x = (self.view.frame.size.width - img.size.width)/2;
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(x, CGRectGetMaxY(labelTitle.frame)+ 32, img.size.width, img.size.height)];
    [loginButton setBackgroundImage:img
                           forState:UIControlStateNormal];
    [loginButton addTarget:self
                    action:@selector(clickLoginButton)
          forControlEvents:UIControlEventTouchUpInside];
    [_successView addSubview:loginButton];
    [self.view addSubview:_successView];

}

- (void)clickLoginButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initRegisterView
{
    NSInteger ytop = 0;
#ifdef IOS7_SDK_AVAILABLE
    if(IOS7_AVAILABLE){
        ytop = 20;
        
    }
#endif

    _registerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+ ytop, self.view.frame.size.width, self.view.frame.size.height -44 - ytop)];
    [_registerScrollView setBackgroundColor:[UIColor clearColor]];
    [_registerScrollView setShowsVerticalScrollIndicator:NO];
    
    _localData = [BDLocalData initWithDataPlist:@"BDLocal"];
    _selectShengIndex = _selectCityIndex = 0;

    UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 14, 76, 35)];
    phoneLabel.backgroundColor  = [UIColor clearColor];
    phoneLabel.textAlignment = UITextAlignmentCenter;
    phoneLabel.contentMode = UIViewContentModeCenter;
    [phoneLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [phoneLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    phoneLabel.text = @"手机号 ：";
    [_registerScrollView addSubview:phoneLabel];
    
    _phoneNumText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame)+8, phoneLabel.frame.origin.y, 212, 35)];
    _phoneNumText.backgroundColor = [UIColor clearColor];
    _phoneNumText.delegate = self;
    [_phoneNumText setContentMode:UIViewContentModeCenter];
    [_phoneNumText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _phoneNumText.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneNumText setReturnKeyType:UIReturnKeyNext];
    [_phoneNumText setBorderStyle:UITextBorderStyleRoundedRect];

    [_phoneNumText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_registerScrollView addSubview:_phoneNumText];
    
    UILabel * passwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(phoneLabel.frame) +20 , CGRectGetMaxX(phoneLabel.frame) -10, CGRectGetHeight(phoneLabel.frame))];
    
    passwdLabel.backgroundColor  = [UIColor clearColor];
    passwdLabel.textAlignment = UITextAlignmentCenter;
    passwdLabel.contentMode = UIViewContentModeCenter;
    passwdLabel.text = @"登录密码 ：";
    [passwdLabel setTextColor:[UIColor colorWithHexValue:0x333333]];

    [passwdLabel setFont:[UIFont boldSystemFontOfSize:15]];

    [_registerScrollView addSubview:passwdLabel];
    
    _paswdText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwdLabel.frame)+8, passwdLabel.frame.origin.y, CGRectGetWidth(_phoneNumText.frame), CGRectGetHeight(_phoneNumText.frame))];
    _paswdText.backgroundColor = [UIColor clearColor];
    _paswdText.delegate = self;
    [_paswdText setContentMode:UIViewContentModeCenter];
    [_paswdText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_paswdText setBorderStyle:UITextBorderStyleRoundedRect];
    [_paswdText setSecureTextEntry:YES];
    _paswdText.returnKeyType = UIReturnKeyNext;
    [_paswdText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_registerScrollView addSubview:_paswdText];

    UILabel * passwdAgainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(passwdLabel.frame) +20 , CGRectGetMaxX(phoneLabel.frame) -10, CGRectGetHeight(phoneLabel.frame))];
    
    passwdAgainLabel.backgroundColor  = [UIColor clearColor];
    passwdAgainLabel.textAlignment = UITextAlignmentCenter;
    passwdAgainLabel.contentMode = UIViewContentModeCenter;
    passwdAgainLabel.text = @"确认密码 ：";
    [passwdAgainLabel setTextColor:[UIColor colorWithHexValue:0x333333]];

    [passwdAgainLabel setFont:[UIFont boldSystemFontOfSize:15]];

    [_registerScrollView addSubview:passwdAgainLabel];
    
    _passwdAgainText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwdAgainLabel.frame)+8, passwdAgainLabel.frame.origin.y, CGRectGetWidth(_paswdText.frame), CGRectGetHeight(_paswdText.frame))];
    _passwdAgainText.backgroundColor = [UIColor clearColor];
    _passwdAgainText.delegate = self;
    [_passwdAgainText setContentMode:UIViewContentModeCenter];

    [_passwdAgainText setBorderStyle:UITextBorderStyleRoundedRect];
    [_passwdAgainText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_passwdAgainText setSecureTextEntry:YES];
    _passwdAgainText.returnKeyType = UIReturnKeyNext;
    [_passwdAgainText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_registerScrollView addSubview:_passwdAgainText];

    UILabel * userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(passwdAgainLabel.frame) +20 , CGRectGetMaxX(phoneLabel.frame)-10, CGRectGetHeight(phoneLabel.frame))];
    
    userNameLabel.backgroundColor  = [UIColor clearColor];
    userNameLabel.textAlignment = UITextAlignmentCenter;
    userNameLabel.contentMode = UIViewContentModeCenter;
    userNameLabel.text = @"会员姓名 ：";
    [userNameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];

    [userNameLabel setFont:[UIFont boldSystemFontOfSize:15]];

    [_registerScrollView addSubview:userNameLabel];
    
    _userNameText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLabel.frame)+8, userNameLabel.frame.origin.y, CGRectGetWidth(_paswdText.frame), CGRectGetHeight(_paswdText.frame))];
    _userNameText.backgroundColor = [UIColor clearColor];
    _userNameText.delegate = self;
    [_userNameText setContentMode:UIViewContentModeCenter];
    [_userNameText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [_userNameText setBorderStyle:UITextBorderStyleRoundedRect];

    _userNameText.returnKeyType = UIReturnKeyNext;
    [_userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_registerScrollView addSubview:_userNameText];
   
    UILabel * loacalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(userNameLabel.frame) +20 , CGRectGetMaxX(phoneLabel.frame) -10, CGRectGetHeight(phoneLabel.frame))];
    
    loacalLabel.backgroundColor  = [UIColor clearColor];
    loacalLabel.textAlignment = UITextAlignmentCenter;
    loacalLabel.contentMode = UIViewContentModeCenter;
    loacalLabel.text = @"所在地区 ：";
    [loacalLabel setTextColor:[UIColor colorWithHexValue:0x333333]];

    [loacalLabel setFont:[UIFont boldSystemFontOfSize:15]];

    [_registerScrollView addSubview:loacalLabel];
    
    BDShengData  * shengData = [_localData.shengArr objectAtIndex:0];
    
    UITextField * tmpTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loacalLabel.frame) +9,loacalLabel.frame.origin.y,100, 35)];
    tmpTextFiled.backgroundColor = [UIColor clearColor];
    [tmpTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    tmpTextFiled.enabled = NO;
    UIImage * img = [UIImage imageNamed:@"buttonArr"];
    NSInteger y  = (CGRectGetHeight(tmpTextFiled.frame) - img.size.height) /2;
    
    UIImageView * tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled.frame) - img.size.width - 5, y, img.size.width, img.size.height)];
    [tmpImg setImage:img];
    [tmpTextFiled addSubview:tmpImg];
    [_registerScrollView addSubview:tmpTextFiled];
    
    _shengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shengButton setFrame:tmpTextFiled.frame];
    [_shengButton setTitle:shengData.shengName
                  forState:UIControlStateNormal];
    [_shengButton setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];
    [_shengButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [_shengButton addTarget:self
                     action:@selector(clickPickerButton)
           forControlEvents:UIControlEventTouchUpInside];
    [_shengButton setContentMode:UIViewContentModeCenter];
    [_shengButton setBackgroundColor:[UIColor clearColor]];
    
    [_registerScrollView addSubview:_shengButton];

    
    
    UITextField * tmpTextFiled2 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tmpTextFiled.frame) +10,tmpTextFiled.frame.origin.y,CGRectGetWidth(tmpTextFiled.frame),CGRectGetHeight(tmpTextFiled.frame))];
    [tmpTextFiled2 setBackgroundColor:[UIColor clearColor]];
    [tmpTextFiled2 setBorderStyle:UITextBorderStyleRoundedRect];
    
    UIImage * img2 = [UIImage imageNamed:@"buttonArr"];

    y  = (CGRectGetHeight(tmpTextFiled2.frame) - img2.size.height) /2;
    
    UIImageView * tmpImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tmpTextFiled2.frame) - img2.size.width - 5, y, img2.size.width, img2.size.height)];
    [tmpImg2 setImage:img];
    [tmpTextFiled2 addSubview:tmpImg2];
    
    [_registerScrollView addSubview:tmpTextFiled2];

    BDCityData * cityData = [shengData.cityArr objectAtIndex:0];
    
    _cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cityButton setFrame:tmpTextFiled2.frame];
    [_cityButton setBackgroundColor:[UIColor clearColor]];
    [_cityButton setTitle:cityData.cityName
                 forState:UIControlStateNormal];
    [_cityButton setContentMode:UIViewContentModeCenter];
    [_cityButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];

    [_cityButton addTarget:self
                    action:@selector(clickPickerButton)
          forControlEvents:UIControlEventTouchUpInside];
    [_cityButton setTitleColor:[UIColor colorWithHexValue:0x333333]
                       forState:UIControlStateNormal];

    [_registerScrollView addSubview:_cityButton];
    
    
    UILabel * severiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(loacalLabel.frame) +20 , CGRectGetMaxX(phoneLabel.frame)-10, CGRectGetHeight(phoneLabel.frame))];
    
    severiceLabel.backgroundColor  = [UIColor clearColor];
    severiceLabel.textAlignment = UITextAlignmentCenter;
    severiceLabel.contentMode = UIViewContentModeCenter;
    severiceLabel.text = @"服务代表 ：";
    [severiceLabel setTextColor:[UIColor colorWithHexValue:0x333333]];

    [severiceLabel setFont:[UIFont boldSystemFontOfSize:15]];

    [_registerScrollView addSubview:severiceLabel];
    
    _recommendPhoneNumText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(severiceLabel.frame)+8, severiceLabel.frame.origin.y, CGRectGetWidth(_paswdText.frame), CGRectGetHeight(_paswdText.frame))];
    _recommendPhoneNumText.backgroundColor = [UIColor clearColor];
    _recommendPhoneNumText.delegate = self;
    [_recommendPhoneNumText setBorderStyle:UITextBorderStyleRoundedRect];
    [_recommendPhoneNumText setContentMode:UIViewContentModeCenter];
    [_recommendPhoneNumText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    _recommendPhoneNumText.returnKeyType = UIReturnKeyDone;
    [_recommendPhoneNumText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_recommendPhoneNumText setPlaceholder:@"请填写服务代表手机号"];
    [_recommendPhoneNumText setFont:[UIFont systemFontOfSize:15]];
    [_registerScrollView addSubview:_recommendPhoneNumText];
    
     img = [UIImage imageNamed:@"register_btn"];
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setFrame:CGRectMake(10, CGRectGetMaxY(_recommendPhoneNumText.frame) + 27, img.size.width, img.size.height)];
    [_registerScrollView addSubview:_registerButton];
    [_registerButton setBackgroundImage:img
                               forState:UIControlStateNormal];
    [_registerButton addTarget:self
                        action:@selector(clickRegisterAction:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [_registerScrollView setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_registerButton.frame))];
    
    
    [self.view addSubview:_registerScrollView];
    [self initPickerView];
    
}
- (void)clickPickerButton
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    _pickerWithToolView.hidden = NO;
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [_pickerView selectRow:0 inComponent:0 animated:NO];
    [_pickerView reloadAllComponents];
}
- (void)initPickerView
{
    _pickerWithToolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 250 + 20 +7, self.view.frame.size.width, 250)];
    [_pickerWithToolView setBackgroundColor:[UIColor clearColor]];
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [toolbar setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(clickPickerView)];
    [toolbar setItems:[NSArray arrayWithObject:barItem]];
    [_pickerWithToolView addSubview:toolbar];
    
    UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(toolbar.frame), self.view.frame.size.width, CGRectGetHeight(_pickerWithToolView.frame) - CGRectGetHeight(toolbar.frame))];
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    [pickerView setShowsSelectionIndicator:YES];
    _pickerView = pickerView;
    [_pickerWithToolView addSubview:pickerView];
    
    [self.view addSubview:_pickerWithToolView];
    _pickerWithToolView.hidden  = YES;
}
#pragma mark ----UIPickerViewDataSource 
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
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
    return 0;
}
#pragma mark -- UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width/2.0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
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
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
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




- (void)clickPickerView {
    _pickerWithToolView.hidden = YES;
    
    BDShengData * shengData = [_localData.shengArr objectAtIndex:_selectShengIndex];
    [_shengButton setTitle:shengData.shengName
                  forState:UIControlStateNormal];
    
    BDCityData * cityData = [shengData.cityArr objectAtIndex:_selectCityIndex];
    [_cityButton setTitle:cityData.cityName
                 forState:UIControlStateNormal];
    
    [_recommendPhoneNumText becomeFirstResponder];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickRegisterAction:(UIButton *)button
{
    if (![_paswdText.text isEqualToString:_passwdAgainText.text]) {
        //两次密码不正确
        [Utility showTipsViewWithText:@"两次密码输入不一致!"];
    }
    else if(![self checkDatainput]) {
        [Utility showTipsViewWithText:@"请填写完整资料"];
    }
    else {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self requestData];
    }

    
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_paswdText]) {
        _paswdText.text = nil;
        
    }
    else if([textField isEqual:_passwdAgainText]) {
        _passwdAgainText.text = nil;
    }

    
    CGFloat height = self.view.frame.size.height - 252;
    if (CGRectGetMaxY(textField.frame) >= height) {
        [_registerScrollView setContentOffset:CGPointMake(0, 120)];
    }
    else {
        [_registerScrollView setContentOffset:CGPointMake(0, 0)];
 
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([textField isEqual:_phoneNumText]) {
        [_phoneNumText resignFirstResponder];
        [_paswdText becomeFirstResponder];
    }
    else if ([textField isEqual:_paswdText]) {
        _paswdText.text = nil;
        [_paswdText resignFirstResponder];
        [_passwdAgainText becomeFirstResponder];
        
    }
    else if([textField isEqual:_passwdAgainText]) {
        _passwdAgainText.text = nil;
        [_passwdAgainText resignFirstResponder];
        [_userNameText becomeFirstResponder];
    }
    else if([textField isEqual:_userNameText]) {
        [_userNameText resignFirstResponder];
        //城市省份出现;
        [self clickPickerButton];
    }

    if ([textField isEqual:_recommendPhoneNumText]) {
        if (![_paswdText.text isEqualToString:_passwdAgainText.text]) {
            //两次密码不正确
            [Utility showTipsViewWithText:@"两次密码输入不一致!"];
            return NO;
        }
        else if(![self checkDatainput]) {
            [Utility showTipsViewWithText:@"请填写完整资料"];
            return NO;
        }
        else {
            [_recommendPhoneNumText resignFirstResponder];
            [self requestData];
        }
    }
    return YES;
}
- (BOOL) checkDatainput
{
    BOOL ret = NO;
    if ([_phoneNumText.text length] > 0 &&
        [_paswdText.text length] > 0    &&
        [_passwdAgainText.text length] >0 &&
        [_userNameText.text length] > 0 ) {
        ret = YES;
    }
    return ret;
}

- (void)requestData
{
    [_requestData cancel];
    
    _requestData = [[BDRequestData alloc] init];
    NSString * passwdStr = _paswdText.text;//[NSString stringWithFormat:@"%@%@",_phoneNumText.text,_paswdText.text];
   // passwdStr = [passwdStr stringFromMD5];
    
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *userName = [NSString stringWithCString:[_userNameText.text UTF8String]
                                               encoding:encode];
    
    BDShengData * shengData = [_localData.shengArr objectAtIndex:_selectShengIndex];
    
    NSString * shengCode = shengData.shengCode;
    BDCityData * cityData = [shengData.cityArr objectAtIndex:_selectCityIndex];
    NSString * cityCode = cityData.cityCode;
    
    NSString * agent = @"";
    if ([_recommendPhoneNumText.text length] > 0) {
        agent = _recommendPhoneNumText.text;
    }
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Register",@"Action",
                          _phoneNumText.text,@"LoginName",
                          passwdStr,@"password",
                          userName,@"name",
                          shengCode,@"sheng",
                          cityCode,@"shi",
                          agent,@"agent",
                          nil];
    __weak BDRegisterCtr * Weak_self = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_requestData loginDataAsync:@""
                             dic:dic onCompletion:^(NSObject *data, NSString *str) {
                                 [MBProgressHUD hideAllHUDsForView:Weak_self.view animated:YES];

                                 NSLog(@"s66666tr ==%@",str);
                                 NSArray * arr = [str componentsSeparatedByString:@"##"];
                                 if ([arr count] == 2) {
                                     NSString * subStr = [arr objectAtIndex:0];
                                     if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                                         //表示成功
                                         //发生页面跳转
                                         
                                         [Weak_self showRegisterSuccessView];
                                         
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
                                 [MBProgressHUD hideAllHUDsForView:Weak_self.view animated:YES];

                                 NSString * errorStr = [error localizedDescription];
                                 [Utility showTipsViewWithText:@"请求失败"];
                             }];


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
