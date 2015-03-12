//
//  BDLeftImgScroll.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-24.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDLeftImgScroll.h"
#import "BDUserDB.h"
#import "NSString+picNamePath.h"

@implementation BDLeftImgScroll

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createContenView];
    }
    return self;
}
- (void)setCarPai:(NSString *)carPai
{
    _carPai = carPai;
    BDUserDB * userDb = [BDUserDB shareInstance];
    BDCarInfo * carInfo = [userDb findWithCarPai:_carPai];
    
    for (UIView * view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    if (carInfo &&
        carInfo.picList &&
        [carInfo.picList count] > 0 ) {
        NSInteger xLeft = 5;
        NSInteger offset = 5;


        int i = 0;
        for (NSString * imgStr in carInfo.picList) {
            UIImage * picImg = [UIImage imageWithContentsOfFile:[imgStr picNamePath]];
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xLeft + (offset + _scrollView.frame.size.height)* i, 0 ,  _scrollView.frame.size.height,  _scrollView.frame.size.height)];
            imgView.backgroundColor = [UIColor clearColor];
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            imgView.clipsToBounds = YES;

            [imgView setImage:picImg];
            [_scrollView addSubview:imgView];
            [_scrollView setContentSize:CGSizeMake(CGRectGetMaxX(imgView.frame) +CGRectGetMaxX(_leftImgVIew.frame), _scrollView.frame.size.height)];
            i++;
        }
    }
}

- (void) createContenView
{
    UIImage * img = [UIImage imageNamed:@"editcar_btn_addpic"];
    UIButton * tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.backgroundColor = [UIColor clearColor];
    [tmpButton setFrame:CGRectMake(0, 0, img.size.width +10 ,img.size.height +10)];
    [tmpButton addTarget:self
                  action:@selector(clickAdd)
        forControlEvents:UIControlEventTouchUpInside];
    _leftImgVIew = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, img.size.width, img.size.height)];
    [_leftImgVIew setBackgroundColor:[UIColor clearColor]];
    [_leftImgVIew setImage:img];

    [tmpButton addSubview:_leftImgVIew];
    [self addSubview:tmpButton];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImgVIew.frame), 10, self.frame.size.width - CGRectGetMaxX(_leftImgVIew.frame) - 10 , img.size.height)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_scrollView];
}

- (void)clickAdd
{
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(clickAddPohoto)]) {
        [self.adelegate clickAddPohoto];
    }
    
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
