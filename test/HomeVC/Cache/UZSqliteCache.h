//
//  UZSqliteCache.h
//  UZai5.2
//
//  Created by UZAI on 14-9-1.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UZCity.h"
@interface UZSqliteCache : NSObject
///插入充值记录表
+(BOOL)insertCityList:(UZCity *)CityList;
///修改历史的状态
+(BOOL)UpdateIsHittoryState:(UZCity *)CityList;

//查询历史的数据
+(NSMutableArray *)QueryHistoryCityList;

///查询城市列表的数据
+(NSMutableArray *)QueryCityList;

///查询热门的城市
+(NSMutableArray *)QueryHotCityList;

//查询出发的城市
+(UZCity *)QueryStartCityList;

//删除表格
+(BOOL)deleteStartCity;
//启动软件的时候出发城市
+(BOOL)insertStartCity:(UZCity *)City;
@end
