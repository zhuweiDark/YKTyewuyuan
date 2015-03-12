//
//  Utility.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-12.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "Utility.h"
#import "MBProgressHUD.h"
@implementation Utility

+(void)showTipsViewWithText:(NSString*)text
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.yOffset = -30.f;
    hud.minSize = CGSizeMake(110, 40);
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}

+(void)showTipsViewWithText:(NSString*)text inView:(UIView*)view
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.yOffset = -30.f;
    hud.minSize = CGSizeMake(110, 40);
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}
//创建带图片的MB
+(void)showMBImageProgressHUDWith:(NSString*)strMessage
                          ReqBool:(BOOL)ret
                             View:(UIView *)view
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    hud.labelText = strMessage;
    [view addSubview:hud];
    UIImage * img =nil;
    if (!ret) {
        //失败
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        img =  [UIImage imageNamed:@"SVProgressHUD.bundle/error-black"];
#else
        img =  [UIImage imageNamed:@"SVProgressHUD.bundle/error.png"];
#endif
        
    }
    else {
        //成功
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        img = [UIImage imageNamed:@"SVProgressHUD.bundle/success-black"];
#else
        img = [UIImage imageNamed:@"SVProgressHUD.bundle/success.png"];
#endif
    }
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height + 25)];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [imgView setImage:img];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imgView;
    hud.margin = 10.f;
    hud.yOffset = -30.f;
    hud.minSize = CGSizeMake(110, 40);
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
    
}

@end
