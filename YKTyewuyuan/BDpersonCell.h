//
//  BDpersonCell.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BDpersonCellDelegate<NSObject>

- (void)requestData:(NSInteger)index ;

@end

@interface BDpersonCell : UITableViewCell
@property (nonatomic,strong) UILabel * leftLabel;
@property (nonatomic,strong) UILabel * seconderLabel;
@property (nonatomic,strong) UIButton * detailButton;
@property (nonatomic,weak)id<BDpersonCellDelegate> adelegate;


@end
