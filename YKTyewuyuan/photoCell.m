//
//  photoCell.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-18.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "photoCell.h"

@implementation photoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 90, 100)];
        [self.imgview1 setContentMode:UIViewContentModeScaleAspectFill];
        self.imgview1.clipsToBounds = YES;
        [self.contentView addSubview:self.imgview1];
        
        self.imgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgview1.frame) +10, 10, 90, 100)];
        [self.imgview2 setContentMode:UIViewContentModeScaleAspectFill];
        self.imgview2.clipsToBounds = YES;

        [self.contentView addSubview:self.imgview2];

        self.imgview3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgview2.frame) +10, 10, 90, 100)];
        [self.imgview3 setContentMode:UIViewContentModeScaleAspectFill];
        self.imgview3.clipsToBounds = YES;

        [self.contentView addSubview:self.imgview3];
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;

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
