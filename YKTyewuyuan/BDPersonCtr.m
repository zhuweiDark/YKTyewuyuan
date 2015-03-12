//
//  BDPersonCtr.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-12.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDPersonCtr.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "searchView.h"
#import "BDPersonView.h"
#import "BDAboutView.h"
#import "BDRequestData.h"
#import "commData.h"

@interface BDPersonCtr (){
    UIView * _buttomView;
    UIButton * _search;
    UIButton * _person;
    UIButton * _about;
    NSInteger   _selectIndex;
    searchView  * _searchView;
    BDPersonView * _personView;
    BDAboutView * _aboutView;
}
@property (nonatomic)NSInteger selectIndex;
@end

@implementation BDPersonCtr
@synthesize selectIndex = _selectIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{

    _selectIndex = selectIndex;
    if (_selectIndex == 0) {
        [self createSearchView];
    }
    else if(_selectIndex == 1) {
        [self createPersonView];
    }
    else if(_selectIndex == 2) {
        [self createAboutView];
    }
    else {
        NSLog(@"未知错误");
    }
}

- (void) createAboutView
{
    
    if (!_aboutView) {
        NSInteger yTop = 0;
        if (IOS7_AVAILABLE) {
            yTop = 20;
        }
        _aboutView = [[BDAboutView alloc] initWithFrame:CGRectMake(0, yTop, self.view.frame.size.width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(_buttomView.frame) - yTop)];
        [self.view addSubview:_aboutView];

        
    }
    [self.view bringSubviewToFront:_aboutView];
    
}


- (void) createSearchView
{
    
    if (!_searchView) {
        NSInteger yTop = 0;
        if (IOS7_AVAILABLE) {
            yTop = 20;
        }

        _searchView = [[searchView alloc] initWithFrame:CGRectMake(0, yTop, self.view.frame.size.width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(_buttomView.frame) - yTop)];
        [self.view addSubview:_searchView];

    }
    [_searchView getCarListInfo];
    [self.view bringSubviewToFront:_searchView];

}

- (void) createPersonView
{
    if (!_personView) {
        NSInteger yTop = 0;
        if (IOS7_AVAILABLE) {
            yTop = 20;
        }

        _personView = [[BDPersonView alloc] initWithFrame:CGRectMake(0, yTop, self.view.frame.size.width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(_buttomView.frame) - yTop)];
        [self.view addSubview:_personView];
    }

    [_personView requestPersonData];
    [self.view bringSubviewToFront:_personView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef IOS7_SDK_AVAILABLE
    if(IOS7_AVAILABLE){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif

    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    [backView setImage:[UIImage imageNamed:@"backgroup"]];
    [self.view addSubview:backView];

    self.navigationController.navigationBarHidden = YES;
    self.selectIndex = 0 ;
    //[self initButtomView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginOut)
                                                 name:LOGIN_OUT
                                               object:nil];
}

- (void) loginOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initButtomView
{
    UIImage * img = [UIImage imageNamed:@"nosel_main"];
    NSInteger yTop = self.view.frame.size.height - img.size.height;
    _buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, yTop+0.5, self.view.frame.size.width, img.size.height)];
    _buttomView.backgroundColor = [UIColor clearColor];
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:_buttomView.bounds];
    [imgView setImage:[UIImage imageNamed:@"title"]];
    imgView.userInteractionEnabled = YES;
    
    _search = [UIButton buttonWithType:UIButtonTypeCustom];
    [_search setFrame:CGRectMake(20, 0, 80, img.size.height)];
    [_search setImage:img
             forState:UIControlStateNormal];
    [_search setImage:[UIImage imageNamed:@"sel_main"]
             forState:UIControlStateHighlighted];
    [_search setImage:[UIImage imageNamed:@"sel_main"]
             forState:UIControlStateSelected];
    [_search setTag:0];
    [_search addTarget:self
                action:@selector(clickButton:)
      forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:_search];
    
    img = [UIImage imageNamed:@"nosel_account"];
    _person = [UIButton buttonWithType:UIButtonTypeCustom];
    [_person setFrame:CGRectMake(CGRectGetMaxX(_search.frame) + 20, 0, 80, img.size.height)];
    [_person setTag:1];
    [_person addTarget:self
                action:@selector(clickButton:)
      forControlEvents:UIControlEventTouchUpInside];
    [_person setImage:img
             forState:UIControlStateNormal];
    [_person setImage:[UIImage imageNamed:@"sel_account"]
             forState:UIControlStateHighlighted];
    [_person setImage:[UIImage imageNamed:@"sel_account"]
             forState:UIControlStateSelected];

    [imgView addSubview:_person];
    
    img = [UIImage imageNamed:@"nosel_about"];
    _about = [UIButton buttonWithType:UIButtonTypeCustom];
    [_about setTag:2];
    [_about setFrame:CGRectMake(CGRectGetMaxX(_person.frame)+20, 0, 80, img.size.height)];
    [_about addTarget:self
               action:@selector(clickButton:)
     forControlEvents:UIControlEventTouchUpInside];
    [_about setImage:img
                      forState:UIControlStateNormal];
    [_about setImage:[UIImage imageNamed:@"sel_about"]
             forState:UIControlStateHighlighted];
    [_about setImage:[UIImage imageNamed:@"sel_about"]
             forState:UIControlStateSelected];

    [imgView addSubview:_about];
    
    [_buttomView addSubview:imgView];
    
    [self.view addSubview:_buttomView];
    
}

- (void)clickButton:(UIButton *)button
{
    _search.selected = NO;
    _person.selected = NO;
    _about.selected = NO;
    button.selected = YES;
    self.selectIndex = button.tag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
