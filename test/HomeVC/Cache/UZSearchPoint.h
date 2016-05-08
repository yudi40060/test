//
//  UZSearchPoint.h
//  UZai5.2
//
//  Created by UZAI on 14-9-16.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UZSearchPoint : NSObject
///查询热门的城市
+(NSMutableArray *)QueryPointList:(NSString *)searchText;

///插入历史记录表
+(BOOL)insertCityList:(NSString  *)searchText;
///插入热门记录表
+(BOOL)insertHotCityList:(NSString  *)searchText;
//查询历史的数据数据
+(NSMutableArray *)QueryHistoryCityList;
//查询热门的数据
+(NSMutableArray *)QueryHotCityList;

//删除历史记录
+(BOOL)DeleteHistory;
// 删除单条历史记录
+(NSMutableArray *)QueryHistoryCityList:(NSInteger)indexNum;


//wp
//插入搜索页热门城市表
+(BOOL)insertSearchHotCityList:(NSString *)hotWordStr;
//查询搜索页热门城市表
+(NSMutableArray *)QuerySearchHotCityList;
//删除搜索页热门城市表格
+(void)deleteSearchHotCityTable;
@end
