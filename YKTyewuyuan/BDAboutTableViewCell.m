//
//  BDAboutTableViewCell.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-18.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDAboutTableViewCell.h"

@implementation BDAboutTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage * img  = [UIImage imageNamed:@"about_home"];
        self.leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, img.size.width, img.size.height)];
        [self.contentView addSubview:self.leftIcon];
        
        self.leftTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftIcon.frame)+5, 10, 240, 40)];
        self.leftTitle.backgroundColor = [UIColor clearColor];
        [self.leftTitle setFont:[UIFont boldSystemFontOfSize:17]];

        [self.contentView addSubview:self.leftTitle];
        
        img = [UIImage imageNamed:@"about_right"];
        self.rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - img.size.width- 10, 20, img.size.width, img.size.height)];
        [self.rightIcon setImage:img];
        [self.contentView addSubview:self.rightIcon];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 54.5, 320, 0.5)];
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
