//
//  QianTableViewCell.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "QianTableViewCell.h"
#import "NSStringEX.h"
#define font_height (15)

@implementation QianTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.titleLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
        [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:self.titleLabel];
        
        self.qianLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x,CGRectGetMaxY(self.titleLabel.frame) + 0, 160, 25)];
        self.qianLabel.font = [UIFont systemFontOfSize:font_height];
        [self.qianLabel setTextColor:[UIColor colorWithHexValue:0x666666]];
        self.qianLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.qianLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100 -10 ,17, 100, 25)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.timeLabel setFont:[UIFont systemFontOfSize:font_height]];
        [self.timeLabel setTextColor:[UIColor colorWithHexValue:0xcccccc]];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        self.changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.frame.origin.x,self.qianLabel.frame.origin.y, 100, 25)];
        self.changeLabel.backgroundColor = [UIColor clearColor];
        self.changeLabel.textAlignment = NSTextAlignmentRight;
        [self.changeLabel setFont:[UIFont systemFontOfSize:font_height]];
        [self.contentView addSubview:self.changeLabel];
        
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
