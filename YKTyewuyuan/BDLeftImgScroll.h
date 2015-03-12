//
//  BDLeftImgScroll.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-24.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BDLeftImgScrollDelegate<NSObject>

- (void)clickAddPohoto;

@end

@interface BDLeftImgScroll : UIView
{
    UIImageView  * _leftImgVIew;
    UIScrollView * _scrollView;
}
@property (nonatomic,strong)NSString * carPai;
@property (nonatomic,weak)id<BDLeftImgScrollDelegate> adelegate;
@end
