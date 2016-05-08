//
//  UZSearchPoint.m
//  UZai5.2
//
//  Created by UZAI on 14-9-16.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZSearchPoint.h"
#import "FMDatabase.h"
#import "UZPoint.h"

#define ER_DATABASE_PATH [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Cache"]

#define DATABAE_PATH [ER_DATABASE_PATH stringByAppendingPathComponent:@"CacheList.sqlite"]
#define DB_PATH [[NSBundle mainBundle] pathForResource:@"note" ofType:@".db"]
@implementation UZSearchPoint
////查询搜索提示的数据
+(NSMutableArray *)QueryPointList:(NSString *)searchText;
{
    NSMutableArray *DataList=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[FMDatabase databaseWithPath:DB_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return DataList;
    }

    NSString *sqlString1=[NSString stringWithFormat:@"SELECT * FROM book WHERE KeyWordPre Like '%@%%' or KeyWordAll Like '%@%%' or KeyWord Like '%@%%' order by Num desc",searchText,searchText,searchText];

    
    FMResultSet *set=[db executeQuery:sqlString1];
    while([set next]) {
        UZPoint *point=[[UZPoint alloc]init];
        point.ID=[set stringForColumn:@"id"];
        point.KeyWord=[set stringForColumn:@"KeyWord"];
        point.KeyWordPre=[set stringForColumn:@"KeyWordPre"];
        point.KeyWordAll=[set stringForColumn:@"KeyWordAll"];
        [DataList addObject:point];
    }
    
    [db close];
    return DataList;
}


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

+(BOOL)QuerySqlExites:(NSString *)tableName searchText:(NSString *)searchText
{
    BOOL flag;
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return false;
    }
    NSString *SqlString=[NSString stringWithFormat:@"select * from %@ where datas like '%@'",tableName,searchText];
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


///插入历史记录表
+(BOOL)insertCityList:(NSString  *)searchText;
{
    if ([self dataPath:ER_DATABASE_PATH]) {
        FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
        if (![db open]) {
            return NO;
        }
        NSString *createTable=@"CREATE  TABLE  IF NOT EXISTS 'HistoryCity' ( datas VARCHAR(100),HistoryTime VARCHAR(100))";
        BOOL __unused bo = [db executeUpdate:createTable];
        
        if (![self QuerySqlExites:@"HistoryCity" searchText:searchText]) {
            NSString *insertString=[NSString stringWithFormat:@"INSERT INTO HistoryCity ('datas',HistoryTime) VALUES ('%@','%@')",searchText,[NSString getCurrentDateTime]];
            bo=[db executeUpdate:insertString];
        }
        else
        {
            //修改热门的状态
            NSString *updateString=[NSString stringWithFormat:@"update HistoryCity set   HistoryTime='%@' where datas like '%@'",[NSString getCurrentDateTime],searchText];
            bo=[db executeUpdate:updateString];
        }
        [db close];
        return bo;
    }
    return NO;
}
///插入热门记录表
+(BOOL)insertHotCityList:(NSString  *)searchText
{
    if ([self dataPath:ER_DATABASE_PATH]) {
        FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
        if (![db open]) {
            return NO;
        }
        NSString *createTable=@"CREATE  TABLE  IF NOT EXISTS 'HotCity' ( datas VARCHAR(100),HistoryTime VARCHAR(100))";
        BOOL __unused bo = [db executeUpdate:createTable];
        
        if (![self QuerySqlExites:@"HotCity" searchText:searchText]) {
            NSString *insertString=[NSString stringWithFormat:@"INSERT INTO HotCity ('datas',HistoryTime) VALUES ('%@','%@')",searchText,[NSString getCurrentDateTime]];
            bo=[db executeUpdate:insertString];
        }
        else
        {
            //修改热门的状态
            NSString *updateString=[NSString stringWithFormat:@"update HotCity set   HistoryTime='%@' where datas like '%@'",[NSString getCurrentDateTime],searchText];
            bo=[db executeUpdate:updateString];
        }
        [db close];
        return bo;
    }
    return NO;
}

//查询历史的数据数据
+(NSMutableArray *)QueryHistoryCityList;
{
    NSMutableArray *cityList=[[NSMutableArray alloc]init];
    NSMutableArray *keyList=[[NSMutableArray alloc] init];
   
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return cityList;
    }
    NSString *SqlString=@"select * from HistoryCity order by HistoryTime  desc   limit  2";
    FMResultSet *set=[db executeQuery:SqlString];
    while([set next]) {
        [cityList addObject:[set stringForColumn:@"datas"]];
        [keyList addObject:[set stringForColumn:@"HistoryTime"]];
    }
     NSMutableArray *list=[[NSMutableArray alloc] initWithObjects:cityList,keyList, nil];
    [db close];
    return list;
}

// 删除单条历史记录
+(NSMutableArray *)QueryHistoryCityList:(NSInteger)indexNum;
{
    NSMutableArray *cityList=[[NSMutableArray alloc]init];
    NSMutableArray *keyList=[[NSMutableArray alloc] init];
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return cityList;
    }
    NSString *SqlString=@"select * from HistoryCity order by HistoryTime  desc";
    FMResultSet *set=[db executeQuery:SqlString];
    while([set next]) {
        [keyList addObject:[set stringForColumn:@"HistoryTime"]];
    }
    if (keyList.count>2) {
        for (NSInteger i=0; i<keyList.count; i++) {
            if (i>1) {
                //删除数据
                NSString *deleteSql = [NSString stringWithFormat:
                                       @"delete from HistoryCity where HistoryTime = '%@'", keyList[i]];
                BOOL res = [db executeUpdate:deleteSql];
                if (res==NO) {
                    NSLog(@"删除失败");
                }
            }
        }
    }
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from HistoryCity where HistoryTime = '%@'", keyList[indexNum]];
    BOOL res = [db executeUpdate:deleteSql];
    if (res==NO) {
        NSLog(@"删除失败");
    }

    NSString *SqlStr=@"select * from HistoryCity order by HistoryTime  desc";
    FMResultSet *setS=[db executeQuery:SqlStr];
    while([setS next]) {
        [cityList addObject:[setS stringForColumn:@"datas"]];
    }
    [db close];
    return cityList;
}

//查询热门的数据
+(NSMutableArray *)QueryHotCityList;
{
    NSMutableArray *cityList=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return cityList;
    }
    NSString *SqlString=@"select * from HotCity";
    FMResultSet *set=[db executeQuery:SqlString];
    while([set next]) {
        [cityList addObject:[set stringForColumn:@"datas"]];
    }
    [db close];
    return cityList;
}
/*
 ///删除出发城市
 +(BOOL)deleteStartCity;
 {
 
 }

 */
+(BOOL)DeleteHistory
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return NO;
    }
    NSString *sqlString=@"DROP TABLE HistoryCity";
    
    BOOL bo=[db executeUpdate:sqlString];
    return bo;
}
///插入搜索热门城市表
+(BOOL)insertSearchHotCityList:(NSString *)hotWordStr
{
    if ([self dataPath:ER_DATABASE_PATH]) {
        FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
        if (![db open]) {
            return NO;
        }
        NSString *createTable=@"CREATE  TABLE  IF NOT EXISTS 'SearchHotCity' ('KeyWord'  VARCHAR(100))";
        BOOL __unused bo = [db executeUpdate:createTable];
        
        NSString *insertString=[NSString stringWithFormat:@"INSERT INTO SearchHotCity ('keyWord') VALUES ('%@')",hotWordStr];
        bo=[db executeUpdate:insertString];
        [db close];
        return bo;
    }
    return NO;
}
//查询搜索页热门城市数据
+(NSMutableArray *)QuerySearchHotCityList
{
    NSMutableArray *cityList=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return cityList;
    }
    NSString *SqlString=@"select * from SearchHotCity";
    FMResultSet *set=[db executeQuery:SqlString];
    while([set next]) {
//        UZHotPoint5_3 *hotCityData=[[UZHotPoint5_3 alloc]init];
//        hotCityData.imgUrl=[set stringForColumn:@"ImgUrl"];
//        hotCityData.keyWord=[set stringForColumn:@"KeyWord"];
        NSString *str = [set stringForColumn:@"KeyWord"];
        [cityList addObject:str];
    }
    [db close];
    return cityList;
}
//删除搜索页热门城市表格
+(void)deleteSearchHotCityTable
{
    NSString *deleteTable=@"delete from SearchHotCity";
    FMDatabase *db=[FMDatabase databaseWithPath:DATABAE_PATH];
    if (![db open]) {
        return;
    }
    BOOL __unused bo = [db executeUpdate:deleteTable];
    if (bo) {
        deleteTable=@"delete  from  SearchHotCity";
        bo=[db executeUpdate:deleteTable];
    }
}
@end
