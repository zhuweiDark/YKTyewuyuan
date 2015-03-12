//
//  BDpersonCell.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDpersonCell.h"
#import "NSStringEX.h"

@implementation BDpersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 40)];
        self.leftLabel.backgroundColor = [UIColor clearColor];
        [self.leftLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
        [self.leftLabel setFont:[UIFont boldSystemFontOfSize:17]];
        
        [self.contentView addSubview:self.leftLabel];
        
        self.seconderLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftLabel.frame) , self.leftLabel.frame.origin.y, 100, CGRectGetHeight(self.leftLabel.frame))];
        self.seconderLabel.backgroundColor = [UIColor clearColor];
        [self.seconderLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.seconderLabel setTextColor:[UIColor colorWithHexValue:0x007aff]];
        [self.contentView addSubview:self.seconderLabel];
        
        self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.detailButton setFrame:CGRectMake(self.frame.size.width - 10 - 45, 25, 45, 22.5)];
        [self.detailButton setBackgroundImage:[UIImage imageNamed:@"account_detail"]
                                     forState:UIControlStateNormal];
        [self.detailButton addTarget:self
                              action:@selector(clickDetailButton:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.detailButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, 320, 0.5)];
        [lineView setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

- (void)clickDetailButton:(UIButton *)button
{
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(requestData:)]) {
        [self.adelegate requestData:button.tag];
    }
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
