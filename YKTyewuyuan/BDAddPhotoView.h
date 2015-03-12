//
//  BDAddPhotoView.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-18.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BDAddPhotoViewDelegate<NSObject>

- (void)refreshPhoto;
@end
@interface BDAddPhotoView : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate> {
    UILabel * titleLabel;
    UIView  * _titleView;
    UITableView * _mainTableView;
}

@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSMutableArray * list;
@property (nonatomic,strong)id<BDAddPhotoViewDelegate>adelegate;
@end
