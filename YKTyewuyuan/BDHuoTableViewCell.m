//
//  BDHuoTableViewCell.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-19.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDHuoTableViewCell.h"
#import "NSStringEX.h"
#define font_height (12)

@implementation BDHuoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage * img = [UIImage imageNamed:@"searchgoods_pic"];
        CGFloat yTop = (81-img.size.height)/2.0f;
        UIImageView * leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, yTop, img.size.width, img.size.height)];
        [leftImgView setImage:img];
        [self.contentView addSubview:leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImgView.frame) +10 , 14, 250, 40)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.titleLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
        [self.contentView addSubview:self.titleLabel];
        
        img  = [UIImage imageNamed:@"searchgoods_money"];
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.titleLabel.frame) +2, img.size.width, img.size.height)];
        [imgView setImage:img];
        [self.contentView addSubview:imgView];
        
        self.qianLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) +3, imgView.frame.origin.y, 30, imgView.frame.size.height)];
        self.qianLabel.backgroundColor = [UIColor clearColor];
        [self.qianLabel setTextColor:[UIColor colorWithHexValue:0x9a9a9a]];
        self.qianLabel.font = [UIFont systemFontOfSize:font_height];
        self.qianLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.qianLabel];
        
        
        img  = [UIImage imageNamed:@"searchgoods_tel"];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.qianLabel.frame)+ 7, CGRectGetMaxY(self.titleLabel.frame) +2, img.size.width, img.size.height)];
        [imgView setImage:img];
        [self.contentView addSubview:imgView];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+3, imgView.frame.origin.y, 100, imgView.frame.size.height)];
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        [self.phoneLabel setTextColor:[UIColor colorWithHexValue:0x9a9a9a]];
        self.phoneLabel.font = [UIFont systemFontOfSize:font_height];
        self.phoneLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.phoneLabel];
        

        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 90  -10 , imgView.frame.origin.y, 90, imgView.frame.size.height)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.timeLabel setTextColor:[UIColor colorWithHexValue:0xcccccc]];
        self.timeLabel.font = [UIFont systemFontOfSize:font_height];
        self.timeLabel.textAlignment = NSTextAlignmentRight ;
        self.timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.timeLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80.5, 320, 0.5)];
        [lineView setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:lineView];


    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
