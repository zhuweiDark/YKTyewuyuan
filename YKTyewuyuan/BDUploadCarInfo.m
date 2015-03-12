//
//  BDUploadCarInfo.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-19.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDUploadCarInfo.h"
#import "BDUserDB.h"
#import "BDRequestData.h"

@implementation BDUploadCarInfo

+ (void)uploadCarOnCompletion:(BDUploadResponseBlock) completionBlock
                      onError:(BDUploadResponseErrorBlock) errorBlock
{
    BDUserDB * db = [BDUserDB shareInstance];
    NSArray * carList =  [db searchNeedUpdateCarList];
    if ([carList count] == 0) {
        
        NSArray  *allCarList = [db getAllCarList];
        static  int picNum = 0;
        for (BDCarInfo * picCarInfo in allCarList) {
            [BDUploadCarInfo uploadPicWithCarInfo:picCarInfo
                                     onCompletion:^(NSObject *data, NSString *str) {
                                         picNum ++;
                                         if (picNum >= [allCarList count] &&
                                             completionBlock) {
                                             completionBlock(data,str);
                                         }
                                     } onError:^(MKNetworkOperation *completedOperation, NSString *error) {
                                         picNum ++;
                                         if (picNum >= [allCarList count] && errorBlock) {
                                             
                                             errorBlock(completedOperation,error);
                                         }
                                     }];

        }

        return;
    }
    //获取到需要更新数据库的
    for (BDCarInfo * carInfo in carList) {
        BDRequestData * request = [[BDRequestData alloc] init];
        NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
        NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary * dicReq = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"SyncCarInfo",@"Action",
                             username,@"UserName",
                             passwdStr,@"Key",
                             carInfo.carPai,@"carnum",
                             carInfo.carType,@"cartype",
                             carInfo.carInsideType,@"carbox",
                             carInfo.sheng,@"szsheng",
                             carInfo.city,@"szshi",
                             [NSString stringWithCString:[carInfo.longSize UTF8String] encoding:encode],@"chang",
                             [NSString stringWithCString:[carInfo.withSize UTF8String] encoding:encode],@"kuan",
                             [NSString stringWithCString:[carInfo.heightSize UTF8String] encoding:encode],@"gao",
                             carInfo.awalySheng,@"czsheng",
                             carInfo.awalyCity,@"czshi",
                             [NSString stringWithCString:[carInfo.weightSize UTF8String] encoding:encode],@"weight",
                             [NSString stringWithCString:[carInfo.volumeSize UTF8String] encoding:encode],@"volume",
                             [NSString stringWithCString:[carInfo.carDriveNum UTF8String] encoding:encode],@"carid",
                             carInfo.carCheckTime,@"cartestdate",
                             nil];
        
        [request loginDataAsync:@""
                            dic:dicReq onCompletion:^(NSObject *data, NSString *str) {
                            
            NSLog(@"str77777 ==%@",str);
            NSArray * arr = [str componentsSeparatedByString:@"##"];
            if ([arr count] == 2) {
                NSString * subStr = [arr objectAtIndex:0];
                if ([[subStr lowercaseString] isEqualToString:@"success"]) {
            BDRequestData  * request = [[BDRequestData alloc] init];
            NSDictionary * tmpdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"returnCarStatus",@"Action",
                                     username,@"UserName",
                                     passwdStr,@"Key",
                                     carInfo.carPai,@"CarNum",
                                     nil];
                    
            [request loginDataAsync:@""
                                dic:tmpdic
                       onCompletion:^(NSObject *data, NSString *str) {
                           NSLog(@"333333str==%@",str);
                           NSArray * arr = [str componentsSeparatedByString:@"##"];
                           if ([arr count] == 2) {
                               NSString * subStr = [arr objectAtIndex:0];
                               if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                                   BDUserDB * userDB = [BDUserDB shareInstance];
                                   [userDB updateCar:carInfo.carPai
                                            NoUpdate:1];

                               }
                           }
                       } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                           NSLog(@"err=%@",error);
                       }];

                    //表示成功
                    [BDUploadCarInfo uploadPicWithCarInfo:carInfo
                                             onCompletion:^(NSObject *data, NSString *str) {
                                                 if (completionBlock) {
                                                     completionBlock(data,str);
                                                 }
                                             } onError:^(MKNetworkOperation *completedOperation, NSString *error) {
                                                 if (errorBlock) {
                                                     errorBlock(completedOperation,error);
                                                 }
                                             }];
                }
                else {
                    //失败
                    NSString * subStr2 = [arr objectAtIndex:1];
                    if ([[subStr2 lowercaseString] isEqualToString:@"delcar"]) {
                        //删除该记录
                        [db deleteUserWithCarPai:carInfo.carPai];
                    }
                    
                }
            }
            else {
                NSLog(@"未知错误");
                if (errorBlock) {
                    errorBlock(nil,@"未知错误");
                }
            }
                                
                                
        }
        onError:^(MKNetworkOperation *completedOperation, NSError *error) {
            
            NSString * errorStr = [error localizedDescription];
            NSLog(@"errorStr=%@",errorStr);
            if (errorBlock) {
                errorBlock(completedOperation,@"请求失败");
            }
        }];

    }
}

+ (void) uploadPicWithCarInfo:(BDCarInfo *)carInfo
                 onCompletion:(BDUploadResponseBlock) completionBlock
                      onError:(BDUploadResponseErrorBlock) errorBlock
{
    if ([carInfo.picList count] == 0 &&errorBlock) {
        completionBlock(nil,@"同步成功");
        return;
    }
    //看看该车有没有照片

    
    NSMutableArray * picFlag = [[NSMutableArray alloc] initWithArray:[carInfo.picListFlag componentsSeparatedByString:@","]];
    
    NSAssert([picFlag count] == [carInfo.picList count], @"图片出问题了");
    
    static int index = 0;
    index = 0;
    for (NSString * keyStr in carInfo.picList) {
        if ([keyStr  isEqualToString:@""]) {
            index ++;
            if (index >= [carInfo.picList count] && completionBlock) {
                completionBlock (nil,nil);

            }
            continue;
        }
        NSInteger indexFlag = [carInfo.picList indexOfObject:keyStr];
        NSAssert(indexFlag != NSNotFound, @"图片下标出问题了");
        
        if ([[picFlag objectAtIndex:indexFlag] integerValue]  == 1
            || [carInfo.picList count] ==0) {
            index ++;
            if (index >= [carInfo.picList count]&& completionBlock) {
                completionBlock (nil,nil);
                
            }

            continue;
        }
        BDRequestData * req = [[BDRequestData alloc] init];
        [req postFile:keyStr
         onCompletion:^(NSObject *data, NSString *str) {
             index ++;
             NSArray * arr = [str componentsSeparatedByString:@"##"];
             NSString * secondeStr = @"空数据";
             if ([arr count] == 2) {
                 NSString * subStr = [arr objectAtIndex:0];
                 if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                     [picFlag replaceObjectAtIndex:[carInfo.picList indexOfObject:keyStr] withObject:@"1"];
                     
                 }
                 secondeStr = [arr objectAtIndex:1];
             }
             
             if (index >= [carInfo.picList count]) {
                 
                 BDUserDB * userDB = [BDUserDB shareInstance];
                 [userDB updatePic:carInfo.carPai
                               pic:carInfo.picList
                          flagList:picFlag];
                 if (completionBlock) {
                     completionBlock(data,secondeStr);
                 }
             }
             NSLog(@"st88888r ===%@",str);
         } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
             index ++;
             NSString * errorStr = [error localizedDescription];
             NSLog(@"errorStr=%@",errorStr);
             if (index >= [carInfo.picList count] && errorBlock) {
                 errorBlock(completedOperation,@"请求失败");
             }
             
             
         }];
    }

}

+ (void)uploadCarWithCarPai:(NSString *)CarPai
               OnCompletion:(BDUploadResponseBlock) completionBlock
                    onError:(BDUploadResponseErrorBlock) errorBlock
{
    if (!CarPai && [CarPai length] == 0) {
        errorBlock(nil,nil);
        return;
    }
    BDUserDB * db = [BDUserDB shareInstance];
    BDCarInfo * carInfo = [db findWithCarPai:CarPai];
    
    BDRequestData * request = [[BDRequestData alloc] init];
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:USerNameTxt];
    NSString * passwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswdTxt];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSDictionary * dicReq = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"SyncCarInfo",@"Action",
                             username,@"UserName",
                             passwdStr,@"Key",
                             carInfo.name,@"name",
                             carInfo.iphoneNum,@"tel",
                             carInfo.idcard,@"idcard",
                             carInfo.youka,@"youka",
                             [NSString stringWithFormat:@"%d",carInfo.guanggao],@"guanggao",
                             carInfo.carPai,@"carnum",
                             carInfo.carType,@"cartype",
                             carInfo.carInsideType,@"carbox",
                             carInfo.sheng,@"szsheng",
                             carInfo.city,@"szshi",
                             [NSString stringWithCString:[carInfo.longSize UTF8String] encoding:encode],@"chang",
                             [NSString stringWithCString:[carInfo.withSize UTF8String] encoding:encode],@"kuan",
                             [NSString stringWithCString:[carInfo.heightSize UTF8String] encoding:encode],@"gao",
                             carInfo.awalySheng,@"czsheng",
                             carInfo.awalyCity,@"czshi",
                             [NSString stringWithCString:[carInfo.weightSize UTF8String] encoding:encode],@"weight",
                             [NSString stringWithCString:[carInfo.volumeSize UTF8String] encoding:encode],@"volume",
                             [NSString stringWithCString:[carInfo.carDriveNum UTF8String] encoding:encode],@"carid",
                             carInfo.carCheckTime,@"cartestdate",
                             nil];
        
    [request loginDataAsync:@""
                        dic:dicReq onCompletion:^(NSObject *data, NSString *str) {
                            
                            NSLog(@"str77777 ==%@",str);
                            NSArray * arr = [str componentsSeparatedByString:@"##"];
                            if ([arr count] == 2) {
                                NSString * subStr = [arr objectAtIndex:0];
                                if ([[subStr lowercaseString] isEqualToString:@"success"]) {
                                    //表示成功
                                    [BDUploadCarInfo uploadPicWithCarInfo:carInfo
                                                             onCompletion:^(NSObject *data, NSString *str) {
                                                                 if (completionBlock) {
                                                                     completionBlock(data,str);
                                                                 }
                                                             } onError:^(MKNetworkOperation *completedOperation, NSString *error) {
                                                                 if (errorBlock) {
                                                                     errorBlock(completedOperation,error);
                                                                 }
                                                             }];
                                }
                                else {
                                    //失败
                                    NSString * subStr2 = [arr objectAtIndex:1];
                                    if ([[subStr2 lowercaseString] isEqualToString:@"delcar"]) {
                                        //删除该记录
                                        [db deleteUserWithCarPai:carInfo.carPai];
                                    }
                                    else {
                                        completionBlock(data,subStr2);
                                    }
                                    
                                }
                            }
                            else {
                                NSLog(@"未知错误");
                                if (errorBlock) {
                                    errorBlock(nil,@"未知错误");
                                }
                            }
                            
                            
                        }
                    onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                        
                        NSString * errorStr = [error localizedDescription];
                        NSLog(@"errorStr=%@",errorStr);
                        if (errorBlock) {
                            errorBlock(completedOperation,@"请求失败");
                        }
                    }];
    

    
}

@end
