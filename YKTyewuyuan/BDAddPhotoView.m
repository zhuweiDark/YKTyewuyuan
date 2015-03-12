//
//  BDAddPhotoView.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-18.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDAddPhotoView.h"
#import "AppDelegate.h"
#import <UIKit/UIImagePickerController.h>
#import "photoCell.h"
#import "NSData+MD5Digest.h"
#import "BDUserDB.h"
#import "NSString+picNamePath.h"

@implementation BDAddPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self initSearchCarView];

        self.list = [[NSMutableArray alloc]init];
        
        [self createTableView];
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    titleLabel.text = _title;
    BDUserDB * db = [BDUserDB shareInstance];
    BDCarInfo * carInfo  = [db findWithCarPai:_title];
    [self.list addObjectsFromArray: carInfo.picList];
    
}
- (void) createTableView
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.frame.size.width, self.frame.size.height - CGRectGetHeight(_titleView.frame))];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [_mainTableView setRowHeight:120];
    [_mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_mainTableView];
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
    [titleLabel setFont:[UIFont boldSystemFontOfSize:27]];

    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setContentMode:UIViewContentModeCenter];
    [_titleView addSubview:titleLabel];
    
    
    img = [UIImage imageNamed:@"btn_back3"];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 7, img.size.width, img.size.height)];
    [backButton setBackgroundImage:img
                          forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(backButton)
         forControlEvents:UIControlEventTouchUpInside];
    
    [_titleView addSubview:backButton];
    
    
    img = [UIImage imageNamed:@"camerpic_btn_camer"];
    NSInteger x = self.frame.size.width - img.size.width - 10;
    UIButton * saveButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(x, 7, img.size.width, img.size.height)];
    [saveButton setBackgroundImage:img
                          forState:UIControlStateNormal];
    [saveButton addTarget:self
                   action:@selector(clickAddPhto)
         forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:saveButton];
    
    [self addSubview:_titleView];
    
}

- (void)clickAddPhto
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self];
    
}

- (void)backButton
{
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(refreshPhoto)]) {
        [self.adelegate refreshPhoto];
    }
    [self removeFromSuperview];
    
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = [self.list count]/3;
    if ([self.list count] %3 != 0) {
        row += 1;
    }
    return row ;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * celIndex = @"celIndex";
    photoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"celIndex"];
    if (!cell) {
        cell = [[photoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:celIndex];
    }
    
    NSInteger row = indexPath.row;
    NSInteger index = row * 3;
    NSString * str = nil;
    cell.imgview1.image = nil;
    cell.imgview2.image = nil;
    cell.imgview3.image = nil;

    if (index + 0 <[self.list count]) {
        str = [self.list objectAtIndex:index +0];
        NSString * strPath = [str picNamePath];
        cell.imgview1.image = [UIImage imageWithContentsOfFile:strPath];
    }
    if (index +1 <[self.list count]) {
        str = [self.list objectAtIndex:index +1];
        NSString * strPath = [str picNamePath];
        cell.imgview2.image = [UIImage imageWithContentsOfFile:strPath];

    }
    if (index +2 <[self.list count]) {
        str = [self.list objectAtIndex:index +2];
        NSString * strPath = [str picNamePath];
        cell.imgview3.image = [UIImage imageWithContentsOfFile:strPath];
        
    }

    return cell;
    
}



//load user image
- (void)UesrImageClicked
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self];
}


#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        UIViewController * rootViewCTR = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
        [rootViewCTR presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{

    }];

    [self setShowStatusBar];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0);
    
    
    NSString * picName = [BDCarInfo getPicName:self.title];
	NSString * strPath = [picName picNamePath];
    
    [imageData writeToFile:strPath
                atomically:YES];
    [self.list addObject:picName];
    
    
    BDUserDB  * db = [BDUserDB shareInstance];
    [db updatePic:self.title
              pic:self.list];
    [_mainTableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

    [self setShowStatusBar];
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    [[UIApplication  sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}

- (void) setShowStatusBar
{
    [[UIApplication  sharedApplication] setStatusBarHidden:NO
                                             withAnimation:UIStatusBarAnimationNone];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
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
