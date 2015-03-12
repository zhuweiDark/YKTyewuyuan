//
//  BDRequestData.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-12.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDRequestData.h"
#import "VEngine.h"
#import "BDCarInfo.h"
#import "NSString+picNamePath.h"

@interface BDRequestData()
{
    VEngine  * _engine;
    
}
@property (nonatomic,strong) MKNetworkOperation *netoperator;

@end
@implementation BDRequestData
- (id) init
{
    self  = [super init];
    if (self) {
        _engine = [[VEngine alloc] initWithHostName:@"www.sijiykt.com/AndroidSalesman.shtml"];
    }
    
    return self;
}
- (void)loginDataAsync:(NSString *)path
                  dic:(NSDictionary *)dic
         onCompletion:(BDRequestCompletionResponseBlock) completionBlock
              onError:(BDRequestCompletionResponseErrorBlock) errorBlock
{
    self.netoperator = [_engine operationWithPath:path
                                               params:dic
                                           httpMethod:@"GET"
                                  requireVersionParam:YES];
    
    
    __weak BDRequestData * c_self = self;
    [self.netoperator addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         //获取completedOperation的返回数据
         
         //gbk编码
         unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
         NSData *responseData = [completedOperation responseData];
         NSString *valueString = [[NSString alloc] initWithData:responseData encoding:encode];
        
         completionBlock(completedOperation.responseData,valueString);
         [c_self cleanNetOperation];
         
         
     }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error) {
         //错误处理
         errorBlock(completedOperation, error);
         [c_self cleanNetOperation];
     }];
    //加入处理函数
    [_engine enqueueOperation:self.netoperator forceReload:YES];
    

}
- (void)postFile:(NSString *)key
    onCompletion:(BDRequestCompletionResponseBlock) completionBlock
         onError:(BDRequestCompletionResponseErrorBlock) errorBlock
{
    
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
    NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
    

    NSDictionary * picDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SyncCarPic",@"method",
                                                    username,@"UserName",
                                                    passwdStr,@"Key", nil];
//    VEngine * egineTest = [[VEngine alloc] initWithHostName:@"123.118.221.12:8090/laba_web/AndroidDriver.shtml"];
    self.netoperator = [_engine operationWithPath:@""
                                           params:picDic
                                       httpMethod:@"GET"
                              requireVersionParam:YES];
    
    
    __weak BDRequestData * c_self = self;

    
    NSString * strPath = [key picNamePath];
    
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData * dataD = [strPath dataUsingEncoding:encode];
    
    NSString *strPicPath = [[NSString alloc] initWithBytes:[dataD bytes]
                                                   length:[dataD length]
                                                 encoding:encode];
    

    [self.netoperator addFile:strPicPath forKey:@"carpic"];
    [self.netoperator addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         //获取completedOperation的返回数据
         //gbk编码
         unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
         NSData *responseData = [completedOperation responseData];
         NSString *valueString = [[NSString alloc] initWithData:responseData encoding:encode];
         NSLog(@"valueString==%@",valueString);
         completionBlock(completedOperation.responseData,valueString);
         [c_self cleanNetOperation];
         
         
     }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error) {
         //错误处理
         errorBlock(completedOperation, error);
         [c_self cleanNetOperation];
     }];
    //加入处理函数
    [_engine enqueueOperation:self.netoperator forceReload:YES];

    
}
- (void)cancel
{
    [self cleanNetOperation];
    
}

- (void)cleanNetOperation
{
    if (self.netoperator) {
        [self.netoperator cancel];
        self.netoperator = nil;
    }
}
@end
