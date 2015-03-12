//
//  BDUploadCarInfo.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-19.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKNetworkOperation;
typedef void(^BDUploadResponseBlock)(NSObject * data,NSString * str);
typedef void(^BDUploadResponseErrorBlock)(MKNetworkOperation*completedOperation, NSString* error);


@interface BDUploadCarInfo : NSObject

+ (void)uploadCarOnCompletion:(BDUploadResponseBlock) completionBlock
                      onError:(BDUploadResponseErrorBlock) errorBlock;

+ (void)uploadCarWithCarPai:(NSString *)CarPai
               OnCompletion:(BDUploadResponseBlock) completionBlock
                    onError:(BDUploadResponseErrorBlock) errorBlock;


@end
