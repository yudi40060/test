//
//  UZSqliteCache.m
//  UZai5.2
//
//  Created by UZAI on 14-9-1.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZSqliteCache.h"
#import "FMDatabase.h"

#define ER_DATABASE_PATH [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Cache"]

#define DATABAE_PATH [ER_DATABASE_PATH stringByAppendingPathComponent:@"CacheList.sqlite"]
@implementation UZSqliteCache


#pragma mark  private method
///文件夹的创建
+ (BOOL)dataPath:(NSString *)file
{
    NSFileManager *fileManger=[NSFileManager defaultManager];
    if (![fileManger isExecutableFileAtPath:ER_DATABASE_PATH]) {
        BOOL bo=[fileManger createDirectoryAtPath:ER_DATABASE_PATH withIntermediateDirectories:YES attributes:nil error:nil];
        if (bo) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

+(BOOL)QuerySqlExites:(UZCity *)city
{
    BOOL flag;
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return false;
    }
    NSString *SqlString=[NSString stringWithFormat:@"select * from CityList where ID=%lu",(unsigned long)city.ID];
    FMResultSet *set=[db executeQuery:SqlString];
    if  ([set next]) {
        flag =YES;
    }
    else
    {
        flag =NO;
    }
    [db close];
    return flag;
}



#pragma mark  public method
//修改历史的状态
+(BOOL)UpdateIsHittoryState:(UZCity *)CityList
{
    if ([self dataPath:ER_DATABASE_PATH]) {
        FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
        if (![db open]) {
            return NO;
        }
        NSString *updateString=[NSString stringWithFormat:@"update 'CityList' set  IsHistory=%lu ,  HistoryTime='%@' where ID =%lu",(unsigned long)CityList.IsHistory,[NSString getCurrentDateTime],(unsigned long)CityList.ID];
        BOOL bo=[db executeUpdate:updateString];
        return bo;
    }
    return NO;
}



+(BOOL)insertCityList:(UZCity *)CityList;
{
    if ([self dataPath:ER_DATABASE_PATH]) {
        FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
        if (![db open]) {
            return NO;
        }
        NSString *createTable=@"CREATE  TABLE  IF NOT EXISTS 'CityList' (ID INTEGER ,CityName  VARCHAR(100), FristName VARCHAR(100),IsHot   VARCHAR(4),IsHistory  INTEGER,HistoryTime VARCHAR(100))";
        BOOL __unused bo = [db executeUpdate:createTable];
        
        if (![self QuerySqlExites:CityList]) {
            NSString *insertString=[NSString stringWithFormat:@"INSERT INTO CityList ('ID','CityName','FristName','IsHot','IsHistory','HistoryTime') VALUES (%lu,'%@','%@','%@',%lu,'%@')",(unsigned long)CityList.ID,CityList.CityName,CityList.FristName,CityList.IsHot,(unsigned long)CityList.IsHistory,[NSString getCurrentDateTime]];
            bo=[db executeUpdate:insertString];
        }
        else
        {
            //修改热门的状态
            NSString *updateString=[NSString stringWithFormat:@"update CityList set   IsHot=%@ where ID = %lu",CityList.IsHot,(unsigned long)CityList.ID];
            bo=[db executeUpdate:updateString];
        }
        [db close];
        return bo;
    }
    return NO;
}

//查询数据
+(NSMutableArray *)QueryCityList;
{
    NSMutableArray *cityList=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return cityList;
    }
    NSString *SqlString=@"select * from CityList";
    FMResultSet *set=[db executeQuery:SqlString];
    while([set next]) {
        UZCity *city=[[UZCity alloc]init];
        city.ID=[set intForColumn:@"ID"];
        city.CityName=[set stringForColumn:@"CityName"];
        city.FristName=[set stringForColumn:@"FristName"];
        city.IsHot=[set stringForColumn:@"IsHot"];
        city.IsHistory=[set intForColumn:@"IsHistory"];
        [cityList addObject:city];
    }
    [db close];
    return cityList;
}

///查询热门的城市
+(NSMutableArray *)QueryHotCityList;
{
    NSMutableArray *cityList=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return cityList;
    }
    NSString *SqlString=@"select * from CityList where IsHot like '1'";
    
    FMResultSet *set=[db executeQuery:SqlString];
    while([set next]) {
        UZCity *city=[[UZCity alloc]init];
        city.ID=[set intForColumn:@"ID"];
        city.CityName=[set stringForColumn:@"CityName"];
        city.FristName=[set stringForColumn:@"FristName"];
        city.IsHot=[set stringForColumn:@"IsHot"];
        city.IsHistory=[set intForColumn:@"IsHistory"];
        
        [cityList addObject:city];
    }
    [db close];
    return cityList;
}

//查询历史的数据(前3条)
+(NSMutableArray *)QueryHistoryCityList;
{
    NSMutableArray *cityList=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return cityList;
    }
    NSString *sqlString=@"select * from CityList where IsHistory = 1 order by HistoryTime  desc    limit  3";
    
    FMResultSet *set=[db executeQuery:sqlString];
    while([set next]) {
        UZCity *city=[[UZCity alloc]init];
        city.ID=[set intForColumn:@"ID"];
        city.CityName=[set stringForColumn:@"CityName"];
        city.FristName=[set stringForColumn:@"FristName"];
        city.IsHot=[set stringForColumn:@"IsHot"];
        city.IsHistory=[set intForColumn:@"IsHistory"];
        [cityList addObject:city];
    }
    [db close];
    return cityList;
}


//启动软件的时候出发城市
+(BOOL)insertStartCity:(UZCity *)City;
{
    if ([self dataPath:ER_DATABASE_PATH]) {
        FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
        if (![db open]) {
            return NO;
        }
        NSString *createTable=@"CREATE  TABLE  IF NOT EXISTS 'startCity' (ID INTEGER ,CityName  VARCHAR(100))";
        BOOL __unused bo = [db executeUpdate:createTable];
        
        NSString *insertString=[NSString stringWithFormat:@"INSERT INTO startCity ('ID','CityName') VALUES (%lu,'%@')",(unsigned long)City.ID,City.CityName];
        bo=[db executeUpdate:insertString];
        [db close];
        return bo;
    }
    return NO;
}
//查询出发的城市
+(UZCity *)QueryStartCityList;
{

    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return nil;
    }
    NSString *sqlString=@"select * from startCity";
    
    FMResultSet *set=[db executeQuery:sqlString];
    UZCity *city=[[UZCity alloc]init];
    if ([set next]) {
        
        city.ID=[set intForColumn:@"ID"];
        city.CityName=[set stringForColumn:@"CityName"];
    }
    [db close];
    return city;
}
///删除出发城市
+(BOOL)deleteStartCity;
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return NO;
    }
    NSString *sqlString=@"DROP TABLE startCity";
    
   BOOL bo=[db executeUpdate:sqlString];
    return bo;
}


@end
