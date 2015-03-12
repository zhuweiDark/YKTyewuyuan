//
//  LoginCtr.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-11.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "LoginCtr.h"
#import "BDRequestData.h"
#import "Utility.h"
#import "BDPersonCtr.h"
#import "BDRegisterCtr.h"
#import "NSString+MD5Addition.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "commData.h"

@interface LoginCtr ()<UITextFieldDelegate>{
    UITextField * userNameText;
    UITextField * passwdText;
    
    UIButton * loginAction;
    UIButton * registerAction;
    BDRequestData * loginrequest;
    UIScrollView  * headerView;
}

@end

@implementation LoginCtr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSInteger ytop = 0;
#ifdef IOS7_SDK_AVAILABLE
    if(IOS7_AVAILABLE){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        ytop = 20;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;

    }
#endif
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ytop, self.view.frame.size.width, self.view.frame.size.height - ytop)];
    [backView setImage:[UIImage imageNamed:@"backgroup"]];
    [self.view addSubview:backView];
    
    headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ytop, self.view.frame.size.width, self.view.frame.size.height - ytop )];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:headerView];
    
    UIImage * img = [UIImage imageNamed:@"login_title"];
    UIImageView * loginTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 45, img.size.width, img.size.height)];
    loginTitleView.backgroundColor = [UIColor clearColor];
    [loginTitleView setImage:img];
    
    [headerView addSubview:loginTitleView];
    
    img = [UIImage imageNamed:@"login_edittext"];
    NSInteger x =  10;
    UIImageView * loginInputView = [[UIImageView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(loginTitleView.frame)+ 50, img.size.width, img.size.height)];
    
    [loginInputView setBackgroundColor:[UIColor clearColor]];
    [loginInputView setImage:img];
    loginInputView.userInteractionEnabled = YES;
    [headerView addSubview:loginInputView];

    userNameText = [[UITextField alloc] initWithFrame:CGRectMake(55 +loginInputView.frame.origin.x , loginInputView.frame.origin.y + 0, img.size.width - 55 , 45)];
    [userNameText setBackgroundColor:[UIColor clearColor]];
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
    if (userName) {
        [userNameText setText:userName];
    }
    [userNameText setPlaceholder:@"账号"];
    [userNameText setFont:[UIFont boldSystemFontOfSize:15]];
    [userNameText setDelegate:self];
    [userNameText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [userNameText setContentMode:UIViewContentModeCenter];
    [userNameText setReturnKeyType:UIReturnKeyNext];
    [userNameText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [headerView addSubview:userNameText];
    
    passwdText = [[UITextField alloc] initWithFrame:CGRectMake(userNameText.frame.origin.x, CGRectGetMaxY(userNameText.frame)+0, CGRectGetWidth(userNameText.frame), CGRectGetHeight(userNameText.frame))];
    [passwdText setBackgroundColor:[UIColor clearColor]];
    [passwdText setDelegate:self];
    [passwdText setPlaceholder:@"密码"];
    [passwdText setClearsContextBeforeDrawing:YES];
    [passwdText setSecureTextEntry:YES];
    [passwdText setFont:[UIFont boldSystemFontOfSize:15]];
    [passwdText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [passwdText setClearsOnBeginEditing:YES];
    [passwdText setContentMode:UIViewContentModeCenter];
    [passwdText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [passwdText setReturnKeyType:UIReturnKeyDefault];
    [passwdText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [headerView addSubview:passwdText];
    
    
    img = [UIImage imageNamed:@"registerok_login"];
    loginAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginAction setFrame: CGRectMake(10, CGRectGetMaxY(loginInputView.frame) + 20, img.size.width, img.size.height)];
    [loginAction setBackgroundImage:img
                           forState:UIControlStateNormal];
    [loginAction addTarget:self
                    action:@selector(clickButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:loginAction];
    
    img = [UIImage imageNamed:@"login_regbtn"];
    registerAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerAction setFrame: CGRectMake(CGRectGetMaxX(loginAction.frame) + 9,loginAction.frame.origin.y, img.size.width, img.size.height)];
    registerAction.hidden = YES;
    [registerAction setBackgroundImage:img
                           forState:UIControlStateNormal];
    [registerAction addTarget:self
                    action:@selector(clickButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];

    [headerView addSubview:registerAction];

    
}

- (void)clickButtonAction:(UIButton *)button {
    
    if ([button isEqual:loginAction]) {
        //登录操作
        if([userNameText.text length] == 0 ||
           [passwdText.text length] == 0) {
            [Utility showTipsViewWithText:@"请输入用户名或密码"];
            //显示提示
            return;
        }
        [self requestData:userNameText.text
                   passwd:passwdText.text];
    }
    else if([button isEqual:registerAction]) {
        //注册操作
//        if ([userNameText becomeFirstResponder]) {
//            [userNameText resignFirstResponder];
//        }
//        else if([passwdText becomeFirstResponder]) {
//            [passwdText resignFirstResponder];
//        }
        
        BDRegisterCtr * registerCtr = [[BDRegisterCtr alloc] init];
        [self.navigationController pushViewController:registerCtr
                                             animated:YES];
    }
    else{
        NSLog(@"未知操作");
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    
}
#pragma mark ---UITextFieldDelegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:passwdText]) {
        textField.text = nil;
    }
    NSInteger yTop = self.view.frame.size.height - 250;
    
    if (CGRectGetMaxY(textField.frame)  > yTop) {
       [headerView setContentOffset:CGPointMake(0, CGRectGetMaxY(textField.frame) -yTop + 30) ];
    }
    else {
       [headerView setContentOffset:CGPointMake(0, 0)];
       
    }

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([userNameText isEqual:textField]) {
        [textField resignFirstResponder];
        [passwdText becomeFirstResponder];
        return NO;
    }
    else {
        //判断一下两个是否都有值
        if([userNameText.text length] == 0 ||
           [passwdText.text length] == 0) {
            [Utility showTipsViewWithText:@"请输入用户名或密码"];
            //显示提示
            return NO;
        }
        //进行联网请求
        [self requestData:userNameText.text passwd:passwdText.text];
        [passwdText resignFirstResponder];
    }
    return YES;
    
}// called when 'return' key pressed. return NO to ignore.

- (void)requestData:(NSString *)userName passwd:(NSString *)passwd
{
    
    NSString * passwdStr = [NSString stringWithFormat:@"%@%@",userName,passwd];
    passwdStr = [passwdStr stringFromMD5];
    
    [loginrequest cancel];
    
    loginrequest = [[BDRequestData alloc] init];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"Login",@"Action",
                                     userName,@"UserName",
                                     passwdStr,@"Key",
                                     nil];
    __weak LoginCtr * Weak_self = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [loginrequest loginDataAsync:@""
                             dic:dic onCompletion:^(NSObject *data, NSString *str) {
                                 NSLog(@"str ==%@",str);
                                 [MBProgressHUD hideAllHUDsForView:Weak_self.view animated:YES];

                                 NSArray * arr = [str componentsSeparatedByString:@"##"];
                                 if ([arr count] == 2) {
                                     NSString * subStr = [arr objectAtIndex:0];
                                     if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                                         //表示成功
                                        //发生页面跳转
                                         [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:LOGIN_KEY];
                                         [[NSUserDefaults standardUserDefaults] setObject:userName
                                                                                   forKey:USerNameTxt];
                                         [[NSUserDefaults standardUserDefaults] setObject:passwdStr
                                                                                   forKey:UserPasswdTxt];
                                         NSString * name = [arr objectAtIndex:1];
                                         
                                         [[NSUserDefaults standardUserDefaults] setObject:name forKey:UserNameShow];
                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                         BDPersonCtr * personCtr = [[BDPersonCtr alloc] init];
                                         
                                         [Weak_self.navigationController pushViewController:personCtr
                                                       animated:YES];
                                     }
                                     else {
                                         //失败
                                         NSString * subStr2 = [arr objectAtIndex:1];
                                         [Utility showTipsViewWithText:subStr2
                                                                inView:Weak_self.view];
                                     }
                                 }
                                 else {
                                     [Utility showTipsViewWithText:@"未知错误"
                                                            inView:Weak_self.view];
                                 }

                             } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                                 [MBProgressHUD hideAllHUDsForView:Weak_self.view animated:YES];

                                 NSString * errorStr = [error localizedDescription];
                                 [Utility showTipsViewWithText:@"请求失败"
                                                        inView:Weak_self.view];
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
