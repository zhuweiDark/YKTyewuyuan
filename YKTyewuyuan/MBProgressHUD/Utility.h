//
//  Utility.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-12.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject


+(void)showTipsViewWithText:(NSString*)text;

+(void)showTipsViewWithText:(NSString*)text inView:(UIView*)view;

//创建带图片的MB
+(void)showMBImageProgressHUDWith:(NSString*)strMessage
                          ReqBool:(BOOL)ret
                             View:(UIView *)view;

@end
