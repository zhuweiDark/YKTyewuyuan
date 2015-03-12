//
//  BDUSerView.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-17.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDUSerView.h"
#import "QianTableViewCell.h"
#import "BDJifenTableviewCell.h"
#import "NSStringEX.h"

@implementation BDUSerView

- (void)setListInfo:(NSMutableArray *)listInfo
{
    _listInfo = listInfo;
    [_mainTableView reloadData];
}
- (void)setType:(userType)type
{
    _type = type;
    if (_type == user_qian) {
        [titleLabel setText:@"一卡通明细"];
    }
    else if(_type == user_jifen) {
        [titleLabel setText:@"积分明细"];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self initSearchCarView];
        [self createTableView];
    }
    return self;
}

- (void)initSearchCarView
{
    UIImage * img = [UIImage imageNamed:@"title"];

    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    _titleView.backgroundColor = [UIColor clearColor];
    UIImageView * titleImgView = [[UIImageView alloc] initWithFrame:_titleView.bounds];
    [titleImgView setImage:img];
    [titleImgView setUserInteractionEnabled:YES];
    
    [_titleView addSubview:titleImgView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(_titleView.frame))];
    titleLabel.backgroundColor= [UIColor clearColor];
    [titleLabel setText:@""];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setContentMode:UIViewContentModeCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:27]];

    [_titleView addSubview:titleLabel];
    
    
    img = [UIImage imageNamed:@"btn_back"];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 7, img.size.width, img.size.height)];
    [backButton setBackgroundImage:img
                          forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(backButton)
         forControlEvents:UIControlEventTouchUpInside];
    
    [_titleView addSubview:backButton];
    
    
    [self addSubview:_titleView];
    
}

- (void)createTableView
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_titleView.frame))
                                                  style:UITableViewStylePlain];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [_mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_mainTableView setRowHeight:81];
    
    [self addSubview:_mainTableView];
}

#pragma mark ----UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listInfo count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndex = @"cellIndex";
    NSInteger row = indexPath.row;
    if (self.type == user_qian) {
        QianTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
        if (!cell) {
            cell = [[QianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellIndex];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        NSString * tmpStr = [self.listInfo objectAtIndex:row];
        NSArray * arr = [tmpStr componentsSeparatedByString:@"@@"];
        cell.cellId = [arr objectAtIndex:0];
        cell.titleLabel.text = [arr objectAtIndex:1];
        cell.qianLabel.text =[NSString stringWithFormat:@"余额 ：%@",[arr objectAtIndex:3]] ;
        cell.timeLabel.text = [arr objectAtIndex:2];
        NSString * tmp= [arr objectAtIndex:4];
        NSString * str = [arr objectAtIndex:5];
        if ([str integerValue] == 0) {
            cell.changeLabel.text = [NSString stringWithFormat:@"+%@",tmp];
            cell.changeLabel.textColor = [UIColor colorWithHexValue:0x42cd00];
        }
        else{
            cell.changeLabel.text = [NSString stringWithFormat:@"-%@",tmp];
            cell.changeLabel.textColor = [UIColor colorWithHexValue:0xea0116];
 
        }
        return cell;
    }
    else if(self.type == user_jifen) {
        
        BDJifenTableviewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
        if (!cell) {
            cell = [[BDJifenTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellIndex];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString * tmpStr = [self.listInfo objectAtIndex:row];
        NSArray * arr = [tmpStr componentsSeparatedByString:@"@@"];
        cell.cellId = [arr objectAtIndex:0];
        cell.titleLabel.text = [arr objectAtIndex:1];
        cell.qianLabel.text =[NSString stringWithFormat:@"积分余额 ：%@",[arr objectAtIndex:3]] ;
        cell.timeLabel.text = [arr objectAtIndex:2];
        NSString * tmp= [arr objectAtIndex:4];
        NSString * str = [arr objectAtIndex:5];
        if ([str integerValue] == 0) {
            cell.changeLabel.text = [NSString stringWithFormat:@"+%@",tmp];
            cell.changeLabel.textColor = [UIColor colorWithHexValue:0x42cd00];
        }
        else{
            cell.changeLabel.text = [NSString stringWithFormat:@"-%@",tmp];
            cell.changeLabel.textColor = [UIColor  colorWithHexValue:0xea0116];
            
        }
        return cell;

        
    }
    else
    {
        NSLog(@"出现未知错误了");
    }
    return nil;
}


- (void)backButton
{
    
//    if (self.adelegate && [self.adelegate respondsToSelector:@selector(updateCarInfoListData)]) {
//        [self.adelegate updateCarInfoListData];
//    }
    [self removeFromSuperview];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
