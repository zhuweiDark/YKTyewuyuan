//
//  MainViewCtr.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-11.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "MainViewCtr.h"
#import "LoginCtr.h"
#import "BDRequestData.h"
#import "BDPersonCtr.h"
#import "commData.h"

@interface MainViewCtr ()
{
    LoginCtr * loginCtr ;
}

@end

@implementation MainViewCtr

-(id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef IOS7_SDK_AVAILABLE
    if(IOS7_AVAILABLE){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber * loginNum = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_KEY] ;
    
    [self loginViewCtr];
    if (loginNum && [loginNum isKindOfClass:[NSNumber class]]) {
        BOOL loginKey = [loginNum boolValue];
        

        if (loginKey) {
            //登录过了显示个人中心
            [self personViewCtr];
        }
//        else {
//            
//            [self loginViewCtr];
//            
//        }
    }
//    else {
//        
//        [self loginViewCtr];
//    }

}

- (void) personViewCtr
{
    BDPersonCtr * personCtr = [[BDPersonCtr alloc] init];
    [loginCtr.navigationController pushViewController:personCtr
                                         animated:NO];
    
}

- (void) loginViewCtr {
    //显示登录界面
    if (!loginCtr) {
         loginCtr  = [[LoginCtr alloc] init];
        
        [self.navigationController pushViewController:loginCtr
                                             animated:YES];

    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
