//
//  BDRequestData.h
//  CMdriverPro
//
//  Created by zhuwei on 14-9-12.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkOperation.h"

#define  USerNameTxt    (@"USerNameTxt")
#define  UserPasswdTxt  (@"UserPasswdTxt")
#define  UserNameShow   (@"UserNameShow")
#define LOGIN_KEY   (@"LOGIN_KEY")


typedef void(^BDRequestCompletionResponseBlock)(NSObject * data,NSString * str);
typedef void(^BDRequestCompletionResponseErrorBlock)(MKNetworkOperation*completedOperation, NSError* error);

@interface BDRequestData : NSObject

- (void)loginDataAsync:(NSString *)path
                  dic:(NSDictionary *)dic
         onCompletion:(BDRequestCompletionResponseBlock) completionBlock
              onError:(BDRequestCompletionResponseErrorBlock) errorBlock;

- (void)cancel;

- (void)postFile:(NSString *)key
    onCompletion:(BDRequestCompletionResponseBlock) completionBlock
         onError:(BDRequestCompletionResponseErrorBlock) errorBlock;
@end
