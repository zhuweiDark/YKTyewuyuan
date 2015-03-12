//
//  carTableViewCell.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "carTableViewCell.h"
#import "BDRequestData.h"
#import "UIImageView+WebCache.h"
#import "BDLocalData.h"
#import "BDUserDB.h"
#import "NSString+picNamePath.h"
#import "NSStringEX.h"

@implementation carTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexValue:0xffffff];
        // Initialization code
        UIImage * img  = [UIImage imageNamed:@"main_nocar"];
        NSInteger yTop = (81- img.size.height)/2.0;
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, yTop, img.size.width , img.size.height)];
        [self.icon setContentMode:UIViewContentModeScaleAspectFill];
        self.icon.clipsToBounds = YES;
        [self.icon setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.icon];
        
        self.carPai = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) +14, yTop +0, 120, 20)];
        self.carPai.backgroundColor = [UIColor clearColor];
        [self.carPai setFont:[UIFont boldSystemFontOfSize:16]];
        [self.carPai setTextColor:[UIColor colorWithHexValue:0x111111]];
        [self.contentView addSubview:self.carPai];
        
        img = [UIImage imageNamed:@"main_view_user"];
        UIImageView * nameImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.carPai.frame.origin.x, CGRectGetMaxY(self.carPai.frame) +10, img.size.width, img.size.height)];
        [nameImg setImage:img];
        [self.contentView addSubview:nameImg];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameImg.frame)+6, nameImg.frame.origin.y -3, 40, 18)];
        self.name.backgroundColor = [UIColor clearColor];
        [self.name setContentMode:UIViewContentModeTop];
        self.name.font = [UIFont systemFontOfSize:12];
        [self.name setTextColor:[UIColor colorWithHexValue:0x888888]];
        [self.contentView addSubview:self.name];
        
        img = [UIImage imageNamed:@"main_view_pic"];
        
        nameImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.name.frame) +5, CGRectGetMaxY(self.carPai.frame) +10, img.size.width, img.size.height)];
        [nameImg setImage:img];
        [self.contentView addSubview:nameImg];
        
        self.picLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameImg.frame) +6, nameImg.frame.origin.y -3, 60, 18)];
        self.picLabel.backgroundColor = [UIColor clearColor];
        self.picLabel.font = [UIFont systemFontOfSize:12];
        [self.picLabel setContentMode:UIViewContentModeTop];

        [self.picLabel setTextColor:[UIColor colorWithHexValue:0xcc0000]];
        [self.contentView addSubview:self.picLabel];
        
        self.picLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameImg.frame) +6, nameImg.frame.origin.y -3, 60, 18)];
        self.picLabel2.backgroundColor = [UIColor clearColor];
        self.picLabel2.font = [UIFont systemFontOfSize:12];
        [self.picLabel2 setContentMode:UIViewContentModeTop];
        [self.picLabel2 setText:@"张照片"];
        [self.picLabel2 setTextColor:[UIColor colorWithHexValue:0x888888]];
        [self.contentView addSubview:self.picLabel2];

        
        img = [UIImage imageNamed:@"main_upload"];
        yTop = (81- img.size.height)/2.0;

        self.findingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.findingButton setFrame:CGRectMake(self.frame.size.width - img.size.width -12, yTop, img.size.width, img.size.height)];
        [self.findingButton setBackgroundImage: img
                                      forState:UIControlStateNormal];
        [self.findingButton addTarget:self
                               action:@selector(findingButton:)
                     forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.findingButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80.5, 320, 0.5)];
        [lineView setBackgroundColor:[UIColor colorWithHexValue:0xdcdcdc]];
        [self.contentView addSubview:lineView];

        
    }
    return self;
}


- (void)findingButton:(UIButton *)button
{
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(uploadInfo:)]) {
        [self.adelegate uploadInfo:self.carCellInfol.carPai];
    }
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)configureData:(BDCarInfo *)carInfoData
{
    self.carCellInfol = carInfoData;
    self.carPai.text = carInfoData.carPai;
    self.name.text = carInfoData.name;
    CGRect frame = self.picLabel.frame;
    [self.picLabel setText:[NSString stringWithFormat:@"%d",[carInfoData.picList count]]];
    CGSize size = [self.picLabel.text sizeWithFont:self.picLabel.font];
    frame.size.width = size.width;
    self.picLabel.frame = frame;
    frame = self.picLabel2.frame;
    frame.origin.x = CGRectGetMaxX(self.picLabel.frame);
    self.picLabel2.frame = frame;
    {
        BDRequestData * request = [[BDRequestData alloc] init];
        NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
        NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"getCarPic",@"Action",
                              username,@"UserName",
                              passwdStr,@"Key",
                              carInfoData.carPai,@"CarNum",
                              nil];
        
        __weak carTableViewCell * Weak_self = self;
        NSMutableArray * picFlag = [[NSMutableArray alloc] initWithArray:[carInfoData.picListFlag componentsSeparatedByString:@","]];
        if ([carInfoData.picList count] > 0) {

            NSString * picName = [carInfoData.picList objectAtIndex:0];
            NSString * strPath = [picName picNamePath];

            [Weak_self.icon setImage:[UIImage imageWithContentsOfFile:strPath]];

        }
        else {
            [request loginDataAsync:@""
                                dic:dic
                       onCompletion:^(NSObject *data, NSString *str) {
                           
                           NSLog(@"str ==%@",str);
                           NSArray * arr = [str componentsSeparatedByString:@"##"];
                           if ([arr count] == 2) {
                               NSString * subStr = [arr objectAtIndex:0];
                               if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                                   //表示成功
                                   //发生页面跳转
                                   
                                   NSString * secondStr = [arr objectAtIndex:1];
                                   if ([[secondStr lowercaseString] isEqualToString:@"nopic"]) {
                                       if ([carInfoData.picList count] > 0) {

                                           NSString * picName = [carInfoData.picList objectAtIndex:0];
                                           NSString * strPath = [picName picNamePath];

                                           [Weak_self.icon setImage:[UIImage imageWithContentsOfFile:strPath]];
                                           
                                       }
                                       else {
                                           [Weak_self.icon setImage:[UIImage imageNamed:@"main_nocar"]];
                                           
                                       }
                                       
                                   }
                                   else {
                                       carInfoData.picList = [[NSMutableArray alloc] init];
                                       [Weak_self.icon setImageWithURL:[NSURL URLWithString:secondStr]
                                                      placeholderImage:[UIImage imageNamed:@"main_nocar"] options:SDWebImageLowPriority success:^(UIImage *image, BOOL cached) {
                                                          
                                                          NSData *imageData = UIImageJPEGRepresentation(image, 0);
                                                          

                                                          NSString * picName = [BDCarInfo getPicName:carInfoData.carPai];
                                                          NSString * strPath = [picName picNamePath];

                                                          
                                                          [imageData writeToFile:strPath
                                                                      atomically:YES];
                                                          [carInfoData.picList  addObject:picName];
                                                          
                                                          BDUserDB * userDb = [BDUserDB shareInstance];
                                                          [picFlag replaceObjectAtIndex:[carInfoData.picList indexOfObject:picName]
                                                                             withObject:@"1"];
                                                          [userDb updatePic:carInfoData.carPai
                                                                        pic:carInfoData.picList
                                                                   flagList:picFlag];
                                                          
                                                          
                                                      } failure:^(NSError *error) {
                                                          
                                                      }];
                                   }
                                   
                               }
                               else {
                                   [Weak_self.icon setImage:[UIImage imageNamed:@"main_nocar"]];
                               }
                           }
                           
                           
                       }
                    onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                        [Weak_self.icon setImage:[UIImage imageNamed:@"main_nocar"]];
                    }];

        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
