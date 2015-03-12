//
//  BDUserDB.m
//  CMdriverPro
//
//  Created by zhuwei on 14-9-19.
//  Copyright (c) 2014年 zhuwei. All rights reserved.
//

#import "BDUserDB.h"
#import "FMDatabase.h"
#import "NSString+picNamePath.h"

#define DBName  (@"yewuyuan.sqlite")
#define kUserTableName  (@"cartable")

static BDUserDB * _db = nil;
@interface BDUserDB()
{
    NSString * _strPath;
}
@property (nonatomic,strong) FMDatabase * dataBase;

@end

@implementation BDUserDB

+ (id)shareInstance
{
    if (!_db) {
        _db = [[BDUserDB alloc] init];
    }
    return _db;
}

- (id) init {
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========

        _strPath = [DBName picNamePath];

        NSFileManager * fileManager = [NSFileManager defaultManager];
        [fileManager fileExistsAtPath:_strPath];
        [self connect];
                
    }
    return self;
}

- (void) connect {
	if (!_dataBase) {
		_dataBase = [[FMDatabase alloc] initWithPath:_strPath];
	}
    _dataBase.logsErrors = YES;
    _dataBase.traceExecution  = YES;
    _dataBase.checkedOut  = YES;
    _dataBase.crashOnErrors  = YES;
	if (![_dataBase open]) {
		NSLog(@"不能打开数据库");
	}
}


- (void)closeDb
{
    [_dataBase close];
    _db = nil;

}



/**
 * @brief 创建数据库
 */
- (void) createDataBase
{
    FMResultSet * set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kUserTableName]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];

    BOOL existTable = !!count;

    if (existTable) {
        // TODO:是否更新数据库

    } else {
        // TODO: 插入新的数据库
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , carPai VARCHAR(50)  NOT NULL , carType VARCHAR(200) NOT NULL , carInsideType VARCHAR(200)NOT NULL ,sheng VARCHAR(50) NOT NULL, city VARCHAR(50) NOT NULL , longSize VARCHAR(50) NOT NULL, withSize VARCHAR(50) NOT NULL , heightSize VARCHAR(50) NOT NULL , awalySheng VARCHAR(50) NOT NULL , awalyCity VARCHAR(50) NOT NULL , weightSize VARCHAR(50) NOT NULL ,volumeSize VARCHAR(50) NOT NULL , carDriveNum VARCHAR(50) NOT NULL, carCheckTime VARCHAR(50) NOT NULL , noUpdate INTEGER, type INTEGER , picList VARCHAR(300) , picListFlag VARCHAR(300) ,name VARCHAR(300) ,iphoneNum VARCHAR(300) , idcard  VARCHAR(300) , youka VARCHAR(300) , youkaid VARCHAR(300) , yikatong VARCHAR(300) , yikatongid VARCHAR(300) , guanggao INTEGER ,  description VARCHAR(100))",kUserTableName];

        BOOL res = [_dataBase executeUpdate:sql];
        if (!res) {
            NSLog(@"失败");
        }
    }

    
}

- (NSString *) transform:(NSString *)input
{
    if (!input) {
        return @"";
    }
    return input;
}
/**
 * @brief 保存一条车辆记录
 *
 * @param user 需要保存的车辆数据
 */
- (void) saveUser:(BDCarInfo *) car
{
    if ([self findWithCarPai:car.carPai]) {
        return;
    }
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@",kUserTableName];
    
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:13];
    
    
    {
        [keys appendString:@"carPai,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.carPai]];
    }
    
    {
        [keys appendString:@"carType,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.carType]];
    }

    {
        [keys appendString:@"carInsideType,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.carInsideType]];
    }
    {
        [keys appendString:@"sheng,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.sheng]];
    }
    {
        [keys appendString:@"city,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.city]];
    }
    {
        [keys appendString:@"longSize,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.longSize]];
    }
    {
        [keys appendString:@"withSize,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.withSize]];
    }
    {
        [keys appendString:@"heightSize,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.heightSize]];
    }
    {
        [keys appendString:@"awalySheng,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.awalySheng]];
    }
    {
        [keys appendString:@"awalyCity,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.awalyCity]];
    }
    {
        [keys appendString:@"weightSize,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.weightSize]];
    }
    {
        [keys appendString:@"volumeSize,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.volumeSize]];
    }
    {
        [keys appendString:@"carDriveNum,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.carDriveNum]];
    }
    {
        [keys appendString:@"carCheckTime,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.carCheckTime]];
    }
    {
        [keys appendString:@"noUpdate,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInt:car.noUpdate]];
    }
    {
        [keys appendString:@"type,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInt:car.type]];
    }


    {
        [keys appendString:@"name,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.name]];
    }
    {
        [keys appendString:@"iphoneNum,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.iphoneNum]];
    }
    {
        [keys appendString:@"idcard,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.idcard]];
    }
    {
        [keys appendString:@"youka,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.youka]];
    }
    {
        [keys appendString:@"youkaid,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.youkaid]];
    }
    {
        [keys appendString:@"yikatong,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.yikatong]];
    }
    {
        [keys appendString:@"yikatongid,"];
        [values appendString:@"?,"];
        [arguments addObject:[self transform:car.yikatongid]];
    }
    {
        [keys appendString:@"guanggao,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInt:car.guanggao]];
    }

    
    {
        [keys appendString:@"picList,"];
        [values appendString:@"?,"];
        NSMutableString * str = [[NSMutableString alloc] init];
        [str appendString:@""];
        for (int i = 0;i<[car.picList count ]; i++) {
            NSString * tmp =[car.picList objectAtIndex:i];
            if (i == 0) {
                 [str appendString:tmp];
            }
            else
            {
                [str appendFormat:@",%@",tmp];

            }
        }
        [arguments addObject:str];
    }
    
    {
        [keys appendString:@"picListFlag,"];
        [values appendString:@"?,"];
        [arguments addObject:@""];
    }

    {
        [keys appendString:@"description,"];
        [values appendString:@"?,"];
       [arguments addObject:@""];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    
    NSLog(@"%@",query);
   BOOL ret = [_dataBase executeUpdate:query withArgumentsInArray:arguments];
    if (!ret) {
        NSLog(@"添加失败了！！！！");
    }
}

/**
 * @brief 删除一条车辆数据
 *
 * @param carpai 需要删除的车辆的carpai
 */
- (BOOL) deleteUserWithCarPai:(NSString *) carPai
{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE carPai = '%@'",kUserTableName,carPai];
    BOOL ret = [_dataBase executeUpdate:query];
    if (!ret) {
        NSLog(@"删除失败");
    }
    return ret;
}


- (void) updatePic:(NSString *)carPai
               pic:(NSMutableArray *)list
{
    NSString * query = [NSString stringWithFormat:@"UPDATE %@ SET",kUserTableName];
    
    NSMutableString * temp = [NSMutableString stringWithCapacity:1];
    // xxx = xxx;
    if (!carPai) {
        NSLog(@"车辆车牌为空悲剧了！！");
        return;
    }
    NSMutableString * str = [[NSMutableString alloc] init];
    NSMutableString * flag =  [[NSMutableString alloc] init];
    
    [str appendString:@""];
    [flag appendString:@""];
    for (int i = 0;i<[list count] ; i++) {
        NSString * tmp = [list objectAtIndex:i];
        if (i == 0) {
            [str appendString:tmp];
            [flag appendString:@"0"];
        }
        else{
            [str appendFormat:@",%@",tmp];
            [flag appendString:@",0"];
        }
    }
    {
        [temp appendFormat:@" picList = '%@',",str];
    }
    {
        [temp appendFormat:@" picListFlag = '%@',",flag];
    }

    
    [temp appendString:@")"];
    
    query = [query stringByAppendingFormat:@"%@ WHERE carPai = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],carPai];
    NSLog(@"%@",query);
    
    BOOL ret  = [_dataBase executeUpdate:query];
    NSLog(@"ret ==%d",ret);
}

- (void)updateCar:(NSString *)carPai
     sendingState:(carInType) cartype
{
    NSString * query = [NSString stringWithFormat:@"UPDATE %@ SET",kUserTableName];
    
    NSMutableString * temp = [NSMutableString stringWithCapacity:1];
    // xxx = xxx;
    if (!carPai) {
        NSLog(@"车辆车牌为空悲剧了！！");
        return;
    }
    {
        [temp appendFormat:@" type = '%d',",cartype];
    }
    
    
    [temp appendString:@")"];
    
    query = [query stringByAppendingFormat:@"%@ WHERE carPai = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],carPai];
    NSLog(@"%@",query);
    
    [_dataBase executeUpdate:query];

    
}

- (void) updatePic:(NSString *)carPai
               pic:(NSMutableArray *)list
          flagList:(NSMutableArray *)listFlag
{
    NSString * query = [NSString stringWithFormat:@"UPDATE %@ SET",kUserTableName];
    
    NSMutableString * temp = [NSMutableString stringWithCapacity:1];
    // xxx = xxx;
    if (!carPai) {
        NSLog(@"车辆车牌为空悲剧了！！");
        return;
    }
    NSString * str = [list componentsJoinedByString:@","];
    NSString * flag =  [listFlag componentsJoinedByString:@","];
    
    {
        [temp appendFormat:@" picList = '%@',",str];
    }
    {
        [temp appendFormat:@" picListFlag = '%@',",flag];
    }
    
    
    [temp appendString:@")"];
    
    query = [query stringByAppendingFormat:@"%@ WHERE carPai = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],carPai];
    NSLog(@"%@",query);
    
    [_dataBase executeUpdate:query];

    
}


- (void) updateCar:(NSString *)carPai
          NoUpdate:(NSInteger)noUpdate
{
    NSString * query = [NSString stringWithFormat:@"UPDATE %@ SET",kUserTableName];
    
    NSMutableString * temp = [NSMutableString stringWithCapacity:1];
    // xxx = xxx;
    if (!carPai) {
        NSLog(@"车辆车牌为空悲剧了！！");
        return;
    }
    {
        [temp appendFormat:@" noUpdate = '%d',",noUpdate];
    }
    
    [temp appendString:@")"];
    
    query = [query stringByAppendingFormat:@"%@ WHERE carPai = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],carPai];
    NSLog(@"%@",query);
    
    [_dataBase executeUpdate:query];

}
/**
 * @brief 修改车辆的信息
 *
 * @param car 需要修改的车辆信息
 */
- (void) mergeWithCarInfo:(BDCarInfo *) car
{
    
    NSString * query = [NSString stringWithFormat:@"UPDATE %@ SET",kUserTableName];
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    // xxx = xxx;
    if (!car.carPai) {
        NSLog(@"车辆车牌为空悲剧了！！");
        return;
    }
    {
        [temp appendFormat:@" carPai = '%@',",car.carPai];
    }
    if (car.carType) {
        [temp appendFormat:@" carType = '%@',",car.carType];
    }
    if (car.carInsideType) {
        [temp appendFormat:@" carInsideType = '%@',",car.carInsideType];
    }

    if (car.sheng) {
        [temp appendFormat:@" sheng = '%@',",car.sheng];
    }

    if (car.city) {
        [temp appendFormat:@" city = '%@',",car.city];
    }

    if (car.longSize) {
        [temp appendFormat:@" longSize = '%@',",car.longSize];
    }
    if (car.withSize) {
        [temp appendFormat:@" withSize = '%@',",car.withSize];
    }
    if (car.heightSize) {
        [temp appendFormat:@" heightSize = '%@',",car.heightSize];
    }
    if (car.awalySheng) {
        [temp appendFormat:@" awalySheng = '%@',",car.awalySheng];
    }
    if (car.awalyCity) {
        [temp appendFormat:@" awalyCity = '%@',",car.awalyCity];
    }
    if (car.weightSize) {
        [temp appendFormat:@" weightSize = '%@',",car.weightSize];
    }
    if (car.volumeSize) {
        [temp appendFormat:@" volumeSize = '%@',",car.volumeSize];
    }
    if (car.carDriveNum) {
        [temp appendFormat:@" carDriveNum = '%@',",car.carDriveNum];
    }
    if (car.carCheckTime) {
        [temp appendFormat:@" carCheckTime = '%@',",car.carCheckTime];
    }
    {
        [temp appendFormat:@" noUpdate = '%d',",car.noUpdate];
    }
    {
        [temp appendFormat:@" type = '%d',",car.type];
    }
    if (car.name) {
        [temp appendFormat:@" name = '%@',",car.name];
    }
    if (car.iphoneNum) {
        [temp appendFormat:@" iphoneNum = '%@',",car.iphoneNum];
    }
    if (car.idcard) {
        [temp appendFormat:@" idcard = '%@',",car.idcard];
    }
    if (car.youka) {
        [temp appendFormat:@" youka = '%@',",car.youka];
    }
    if (car.youkaid) {
        [temp appendFormat:@" youkaid = '%@',",car.youkaid];
    }
    if (car.yikatong) {
        [temp appendFormat:@" yikatong = '%@',",car.yikatong];
    }
    if (car.yikatongid) {
        [temp appendFormat:@" yikatongid = '%@',",car.yikatongid];
    }
    {
        [temp appendFormat:@" guanggao = '%d',",car.guanggao];
    }
    
    [temp appendString:@")"];
    
    query = [query stringByAppendingFormat:@"%@ WHERE carPai = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],car.carPai];
    NSLog(@"%@",query);

    [_dataBase executeUpdate:query];
    
}

- (carInType)sendingStateWithCarPai:(NSString *)carPai
{
    int sendingState = car_null;
    if (!carPai) {
        return sendingState;
    }
    carPai = [carPai stringByReplacingOccurrencesOfString:@" "
                                               withString:@""];
    
    NSString * query = [NSString stringWithFormat:@"SELECT type FROM %@ WHERE carPai = '%@' ",kUserTableName,carPai];
    FMResultSet * rs = [_dataBase executeQuery:query];
    [rs next];
    sendingState = [rs intForColumn:@"type"];
    
    
    [rs close];
    
    return sendingState;

}

- (BDCarInfo *) findWithCarPai:(NSString * )carPai
{
    if (!carPai) {
        return nil;
    }
    carPai = [carPai stringByReplacingOccurrencesOfString:@" "
                                               withString:@""];
    
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE carPai = '%@' ",kUserTableName,carPai];
    FMResultSet * rs = [_dataBase executeQuery:query];
    [rs next];
    BDCarInfo * car = nil;
    if (rs.columnCount > 0 ) {
        car = [BDCarInfo new];
        car.carPai = [rs stringForColumn:@"carPai"];
        car.carType = [rs stringForColumn:@"carType"];
        car.carInsideType = [rs stringForColumn:@"carInsideType"];
        car.sheng = [rs stringForColumn:@"sheng"];
        car.city = [rs stringForColumn:@"city"];
        car.longSize = [rs stringForColumn:@"longSize"];
        car.withSize = [rs stringForColumn:@"withSize"];
        car.heightSize = [rs stringForColumn:@"heightSize"];
        car.awalySheng = [rs stringForColumn:@"awalySheng"];
        car.awalyCity = [rs stringForColumn:@"awalyCity"];
        car.weightSize = [rs stringForColumn:@"weightSize"];
        car.volumeSize = [rs stringForColumn:@"volumeSize"];
        car.carDriveNum = [rs stringForColumn:@"carDriveNum"];
        car.carCheckTime = [rs stringForColumn:@"carCheckTime"];
        
        car.name = [rs stringForColumn:@"name"];
        car.iphoneNum = [rs stringForColumn:@"iphoneNum"];
        car.idcard = [rs stringForColumn:@"idcard"];
        car.youka = [rs stringForColumn:@"youka"];
        car.youkaid = [rs stringForColumn:@"youkaid"];
        car.yikatong = [rs stringForColumn:@"yikatong"];
        car.yikatongid = [rs stringForColumn:@"yikatongid"];
        car.guanggao = [rs intForColumn:@"guanggao"];
        car.type = [rs intForColumn:@"type"];
        car.noUpdate = [rs intForColumn:@"noUpdate"];
        NSString * picList = [rs stringForColumn:@"picList"];
        
        if ([picList length] > 0) {
            car.picList = [[NSMutableArray alloc] initWithArray:[picList componentsSeparatedByString:@","]];
        }

        car.picListFlag = [rs stringForColumn:@"picListFlag"];
    }

    [rs close];

    return car;
}

- (NSArray *) getAllCarList
{
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@",kUserTableName];

    FMResultSet * rs = [_dataBase executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
	while ([rs next]) {
        BDCarInfo * car = [BDCarInfo new];
        car.carPai = [rs stringForColumn:@"carPai"];
        car.carType = [rs stringForColumn:@"carType"];
        car.carInsideType = [rs stringForColumn:@"carInsideType"];
        car.sheng = [rs stringForColumn:@"sheng"];
        car.city = [rs stringForColumn:@"city"];
        car.longSize = [rs stringForColumn:@"longSize"];
        car.withSize = [rs stringForColumn:@"withSize"];
        car.heightSize = [rs stringForColumn:@"heightSize"];
        car.awalySheng = [rs stringForColumn:@"awalySheng"];
        car.awalyCity = [rs stringForColumn:@"awalyCity"];
        car.weightSize = [rs stringForColumn:@"weightSize"];
        car.volumeSize = [rs stringForColumn:@"volumeSize"];
        car.carDriveNum = [rs stringForColumn:@"carDriveNum"];
        car.carCheckTime = [rs stringForColumn:@"carCheckTime"];
        car.name = [rs stringForColumn:@"name"];
        car.iphoneNum = [rs stringForColumn:@"iphoneNum"];
        car.idcard = [rs stringForColumn:@"idcard"];
        car.youka = [rs stringForColumn:@"youka"];
        car.youkaid = [rs stringForColumn:@"youkaid"];
        car.yikatong = [rs stringForColumn:@"yikatong"];
        car.yikatongid = [rs stringForColumn:@"yikatongid"];
        car.guanggao = [rs intForColumn:@"guanggao"];

        car.type = [rs intForColumn:@"type"];
        car.noUpdate = [rs intForColumn:@"noUpdate"];
        NSString * picList = [rs stringForColumn:@"picList"];
        if ([picList length] > 0 ) {
            car.picList = [[NSMutableArray alloc] initWithArray:[picList componentsSeparatedByString:@","]];
        }

        car.picListFlag = [rs stringForColumn:@"picListFlag"];
        [array addObject:car];
	}
	[rs close];
    return array;

}

- (NSArray *) searchNeedUpdateCarList
{
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE noUpdate = '%d'",kUserTableName,0];
    
    FMResultSet * rs = [_dataBase executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
	while ([rs next]) {
        BDCarInfo * car = [BDCarInfo new];
        car.carPai = [rs stringForColumn:@"carPai"];
        car.carType = [rs stringForColumn:@"carType"];
        car.carInsideType = [rs stringForColumn:@"carInsideType"];
        car.sheng = [rs stringForColumn:@"sheng"];
        car.city = [rs stringForColumn:@"city"];
        car.longSize = [rs stringForColumn:@"longSize"];
        car.withSize = [rs stringForColumn:@"withSize"];
        car.heightSize = [rs stringForColumn:@"heightSize"];
        car.awalySheng = [rs stringForColumn:@"awalySheng"];
        car.awalyCity = [rs stringForColumn:@"awalyCity"];
        car.weightSize = [rs stringForColumn:@"weightSize"];
        car.volumeSize = [rs stringForColumn:@"volumeSize"];
        car.carDriveNum = [rs stringForColumn:@"carDriveNum"];
        car.carCheckTime = [rs stringForColumn:@"carCheckTime"];
        car.name = [rs stringForColumn:@"name"];
        car.iphoneNum = [rs stringForColumn:@"iphoneNum"];
        car.idcard = [rs stringForColumn:@"idcard"];
        car.youka = [rs stringForColumn:@"youka"];
        car.youkaid = [rs stringForColumn:@"youkaid"];
        car.yikatong = [rs stringForColumn:@"yikatong"];
        car.yikatongid = [rs stringForColumn:@"yikatongid"];
        car.guanggao = [rs intForColumn:@"guanggao"];

        car.type = [rs intForColumn:@"type"];
        car.noUpdate = [rs intForColumn:@"noUpdate"];
        NSString * picList = [rs stringForColumn:@"picList"];
        if ([picList length] > 0 ){
            car.picList = [[NSMutableArray alloc] initWithArray:[picList componentsSeparatedByString:@","]];
        }

        car.picListFlag = [rs stringForColumn:@"picListFlag"];
        [array addObject:car];
	}
	[rs close];
    return array;

    
}

- (int) carListCount
{

    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@",kUserTableName];
    
    FMResultSet * rs = [_dataBase executeQuery:query];
    int num = [rs columnCount];
    [rs close];
    
    return num;
}



- (void) deleteLocalData:(NSArray *)needUpdateArr totailArr:(NSArray *)totoailArr
{
    NSArray * needDeleteArr = nil;
    if (!totoailArr || [totoailArr count] == 0) {
        return;
    }
    needDeleteArr = totoailArr;
    if (needUpdateArr && [needUpdateArr count] > 0 ) {
        NSMutableArray * tmpNeedDeleteArr = [[NSMutableArray alloc] initWithCapacity:[totoailArr count]];
        for (int i = 0; i< [totoailArr count]; i++) {
            BDCarInfo * totailCarInfo = [totoailArr objectAtIndex:i];

            int  j = 0;
            for (;j <[needUpdateArr count]; j++) {
                BDCarInfo * needUpdateCarInfo = [needUpdateArr objectAtIndex:j];

                if ([needUpdateCarInfo.carPai isEqualToString:totailCarInfo.carPai ]) {
                    break;
                }
            }
            if (j >= [needUpdateArr count]) {
                //说明没有找到，则需要加入删除队列
                [tmpNeedDeleteArr addObject:totailCarInfo];
            }
        }
        
        needDeleteArr = tmpNeedDeleteArr;
        
    }
    for (BDCarInfo * carInfo in needDeleteArr) {
        [self deleteUserWithCarPai:carInfo.carPai];
    }
    
}

- (void) deleteAllData
{
    
//    NSFileManager *handler = [NSFileManager defaultManager];
//    NSError *error = nil;
//    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//    NSString * filePath  = [docp stringByAppendingString:[NSString stringWithFormat:@"/%@",YIKATONG_SIJI]];
//
//    
//    if (![handler removeItemAtPath:filePath error:&error])
//    {
//    }

    
}

@end
