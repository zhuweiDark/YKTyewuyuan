//
//  NSString+picNamePath.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-22.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "NSString+picNamePath.h"
#import "BDCarInfo.h"

@implementation NSString (picNamePath)

-(NSString * ) picNamePath
{
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath  = [docp stringByAppendingString:[NSString stringWithFormat:@"/%@",YIKATONG_SIJI]];
    NSFileManager * fileDefault = [NSFileManager defaultManager];
    
    BOOL isDir = FALSE;
    
    BOOL isDirExist = [fileDefault fileExistsAtPath:filePath
                                        isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
        
    {
        BOOL bCreateDir =[fileDefault createDirectoryAtPath:filePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
        
        if(!bCreateDir){
            
            NSAssert(FALSE, @"Create Audio Directory Failed.");
        
        }
        
        NSLog(@"%@",filePath);
    }
    
    NSString * strPath = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",self]];
    return strPath;
}

@end
