//
//  searchView.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-15.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "searchView.h"
#import "BDRequestData.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "addCarView.h"
#import "BDCarInfo.h"
#import "BDCarTableView.h"
#import "BDUserDB.h"
#import "BDUploadCarInfo.h"
#import "BDFindHuoView.h"
#import "BDAboutView.h"

@interface searchView ()<addCarViewDelegate,BDCarTableViewDelegate,BDFindHuoViewDelegate,BDAboutViewDelegate> {
    UIView  * _middleView;
    UIView * _titleView;
    UIButton    * _asyButton;
    UIButton    * _addButton;
    BDRequestData * _requestData;
    NSMutableArray * _carInfoList;
    addCarView     * _addCarView;
    BDCarTableView *_carTableView;
    BDFindHuoView * _findHuo;
    BDAboutView  * _aboutView;

}
@property (nonatomic,strong)UIButton * asyButton;
@property (nonatomic,strong)UIButton * addButton;
@property (nonatomic,strong)NSMutableArray * carInfoList;
@property (nonatomic,assign)BOOL        needReq;

@end
@implementation searchView
@synthesize asyButton = _asyButton;
@synthesize addButton = _addButton;
@synthesize carInfoList = _carInfoList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       self.needReq = YES;
        [self initSearchCarView];

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
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(_titleView.frame))];
    titleLabel.backgroundColor= [UIColor clearColor];
    [titleLabel setText:@"管理中心"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:27]];

    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setContentMode:UIViewContentModeCenter];
    [_titleView addSubview:titleLabel];

    
    img = [UIImage imageNamed:@"main_about"];
    UIButton * asyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSInteger yTop = (_titleView.frame.size.height - img.size.height)/2;
    [asyButton setFrame:CGRectMake(10,yTop, img.size.width, img.size.height)];
    [asyButton setBackgroundImage:img
                         forState:UIControlStateNormal];
    [asyButton addTarget:self
                  action:@selector(asyClickButton:)
        forControlEvents:UIControlEventTouchUpInside];
    _asyButton = asyButton;
//    _asyButton.enabled = NO;
    [_titleView addSubview:asyButton];
    
    
    img = [UIImage imageNamed:@"main_addnew"];
    NSInteger x = self.frame.size.width - img.size.width - 10;
    UIButton * addButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:CGRectMake(x, 7, img.size.width, img.size.height)];
    [addButton setBackgroundImage:img
                         forState:UIControlStateNormal];
    [addButton addTarget:self
                  action:@selector(addClickButton:)
        forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:addButton];
    _addButton = addButton;
    _addButton.enabled = YES;
    
    [self addSubview:_titleView];
    
}


- (void) getCarListInfo
{
    
    [self updateRealData:nil];
    
}

- (void)mergeCarDataList:(NSString *)carListStr
{
    NSArray * carList = nil;
    NSMutableArray * carPai = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray * updateIndex = [NSMutableArray arrayWithCapacity:2];
    
    if (!carListStr || [carListStr length] == 0) {
        return;
    }
    
    
    carList = [carListStr componentsSeparatedByString:@"&&"];
    
    if ([carList count] == 0) {
        return;
    }
    for (NSString * strCar in carList) {
        NSArray * tmp = [strCar componentsSeparatedByString:@"@@"];
        if ([tmp count] >= 2) {
            [carPai addObject:[tmp objectAtIndex:0]];
            [updateIndex addObject:[tmp objectAtIndex:1]];
        }
    }
    if (!carPai ||
        [carPai count] ==0 ||
        !updateIndex ||
        [updateIndex count] ==0 ||
        [carPai count] != [updateIndex count]) {
        return;
    }
    NSMutableArray *  neeUpdateArr = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSString * tmpCarPai in carPai) {
        BDCarInfo * tmpInfo = [[BDUserDB shareInstance] findWithCarPai:tmpCarPai];
        if (tmpInfo ) {
            [neeUpdateArr addObject:tmpInfo];
        }
    }
    NSArray * totailArrList = [[BDUserDB shareInstance] getAllCarList];
    [[BDUserDB shareInstance] deleteLocalData:neeUpdateArr
                                    totailArr:totailArrList];

    
    //联网请求数据
    for (NSString * carStr in carPai)
    {
        static  int requestNum = 0;

        BDUserDB * userDB = [BDUserDB shareInstance];
        //先查询
        BDCarInfo * tmpInfo = [userDB findWithCarPai:carStr];
        if (tmpInfo) {
            
            //存在更新状态
            requestNum ++;
            
            if (requestNum >= [carPai count]) {
                [self updateRealData:nil];
            }
        }
        else
        {
            //不存在的话联网请求
            NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
            NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
            
            unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            
            NSData * data = [carStr dataUsingEncoding:encode];
            NSString *caNum = [[NSString alloc] initWithBytes:[data bytes]
                                                       length:[data length]
                                                     encoding:encode];
            
            
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"downCarInfo",@"Action",
                                  username,@"UserName",
                                  passwdStr,@"Key",
                                  caNum,@"CarNum",
                                  nil];
            __weak searchView * weak_self= self;

            BDRequestData * request = [[BDRequestData alloc] init];
            [request loginDataAsync:@""
                                dic:dic onCompletion:^(NSObject *data, NSString *str) {
                                    
                requestNum ++;
                NSLog(@"1111str ==%@",str);
                NSArray * arr = [str componentsSeparatedByString:@"##"];
                if ([arr count] == 2) {
                    NSString * subStr = [arr objectAtIndex:0];
                    if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                        
                        //表示成功
                        NSString * secodeStr = [arr objectAtIndex:1];
                        NSArray * carInfoList = [secodeStr componentsSeparatedByString:@"@@"];
                        if ([carInfoList count] == 13) {
                            BDCarInfo * carInfo = [[BDCarInfo alloc] init];
                            carInfo.carPai = carStr;
                            carInfo.carType = [carInfoList objectAtIndex:0];
                            carInfo.carInsideType = [carInfoList objectAtIndex:1];
                            carInfo.sheng = [carInfoList objectAtIndex:2];
                            carInfo.city = [carInfoList objectAtIndex:3];
                            carInfo.longSize = [carInfoList objectAtIndex:4];
                            carInfo.withSize = [carInfoList objectAtIndex:5];
                            carInfo.heightSize = [carInfoList objectAtIndex:6];
                            carInfo.awalySheng = [carInfoList objectAtIndex:7];
                            carInfo.awalyCity = [carInfoList objectAtIndex:8];
                            carInfo.weightSize = [carInfoList objectAtIndex:9];
                            carInfo.volumeSize = [carInfoList objectAtIndex:10];
                            carInfo.carDriveNum = [carInfoList objectAtIndex:11];
                            carInfo.carCheckTime = [carInfoList objectAtIndex:12];
                            NSInteger index= [carPai indexOfObject:carInfo.carPai];
                            if (index != NSNotFound) {
                                carInfo.noUpdate = [[updateIndex objectAtIndex:index] integerValue];
                            }
                            [userDB saveUser:carInfo];
                            
                        }
                    }
                }
                if (requestNum >= [carPai count]) {
                    [weak_self updateRealData:nil];
                }
                                    
                                    
            } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                
                requestNum ++;
                if (requestNum >= [carPai count]) {
                    [weak_self updateRealData:nil];
                }

                
            }];

        }

    }
    
        
        
    

    
}

- (void)updateRealData:(NSMutableArray *)arr
{
    NSArray * resArr = [[BDUserDB shareInstance] getAllCarList];
    if ([resArr count] > 0) {
        _addCarView.adelegate = nil;
        
        self.carInfoList = [[NSMutableArray alloc] initWithArray:resArr];
        
        if (!_carTableView) {
            _carTableView = [[BDCarTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(_titleView.frame) )];
            self.needReq = YES;
            [self addSubview:_carTableView];

        }
        _carTableView.listCar = self.carInfoList;

        _carTableView.aadelegate = self;
        [self bringSubviewToFront:_carTableView];
    }
    
}

- (void)findHuo:(NSString * )carPai
{
    [_findHuo removeFromSuperview];
    _findHuo = nil;
    //if (!_findHuo) {
        _findHuo = [[BDFindHuoView alloc] initWithFrame:self.bounds];
    //}
    self.needReq = NO;
    _findHuo.adelegate = self;
    _findHuo.carPai = carPai;
    [self addSubview:_findHuo];
    
}

- (void)backToRespond
{
    self.needReq = YES ;
    [self updateRealData:nil];
}
- (void)addClickButton:(UIButton *)button
{
    [self createAddCarView:nil];
}

- (void)createAddCarView:(BDCarInfo *)carInfo
{
    [_addCarView removeFromSuperview];
    [_titleView removeFromSuperview];
    [_middleView removeFromSuperview];
    _addCarView = nil;
    
    //if (!_addCarView) {
        _addCarView  = [[addCarView alloc] initWithFrame:self.bounds];
        
    //}
    if (carInfo) {
        [_addCarView setCarInfo:carInfo];
    }
    self.needReq = NO;
    _addCarView.adelegate = self;
    [self addSubview:_addCarView];

    
}
- (void)asyClickButton:(UIButton *)button
{
    [_addCarView removeFromSuperview];
    [_titleView removeFromSuperview];
    [_middleView removeFromSuperview];
    [_aboutView removeFromSuperview];
    
    //if (!_aboutView) {
        _aboutView = [[BDAboutView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(self.frame) - 0)];
        [self addSubview:_aboutView];
        
    //}
    _aboutView.adelegate = self;
    [self bringSubviewToFront:_aboutView];

}


- (void) createNoSearchView
{
//    if (!_middleView ) {
//        [_middleView removeFromSuperview];
//        _middleView = nil;
//    }
////    _asyButton.enabled = NO;
//
//    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(_titleView.frame) )];
//    [_middleView setBackgroundColor:[UIColor clearColor]];
//    
//    UIImageView * imgView = [[UIImageView alloc] initWithFrame:_middleView.bounds];
//    [imgView setImage:[UIImage imageNamed:@"main_notcar"]];
//    [_middleView addSubview:imgView];
//    self.needReq = YES;
//    [self addSubview:_middleView];
}

#pragma mark ---- addCarViewDelegate

- (void) updateCarInfoListData
{
    self.needReq = YES;
    [self addSubview:_titleView];
    [self getCarListInfo];
    //读取本地数据，如果本地有数据直接用tableView显示
//    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:BDCarInfoData];
//    if (dic &&
//        [dic isKindOfClass:[NSDictionary class]]&&
//        [dic count] > 0) {
//        NSArray * carInfoList = [dic allValues];
//        if ([carInfoList count] > 0) {
//            //说明有本地数据
//            
//        }
//    }
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
