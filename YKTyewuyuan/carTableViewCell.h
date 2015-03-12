//
//  carTableViewCell.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDCarInfo.h"
@protocol carTableViewCellDelegate <NSObject>

- (void) uploadInfo:(NSString *)carPai;
@end

@interface carTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView * icon;
@property (nonatomic,strong) UILabel * carPai;
@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) UILabel * picLabel;
@property (nonatomic,strong) UILabel * picLabel2;
@property (nonatomic,strong) UIButton   * findingButton;
@property (nonatomic,strong) BDCarInfo * carCellInfol;
@property (nonatomic,weak) id<carTableViewCellDelegate> adelegate;

- (void)configureData:(BDCarInfo *)carInfoData;

@end
