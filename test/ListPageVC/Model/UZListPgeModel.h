//
//  UZListPgeModel.h
//  UZai5.2
//
//  Created by uzai on 14-9-12.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UZCity.h"

@interface UZListPgeModel : NSObject

@property (nonatomic, copy)  NSString * travelClassID;   //线路类型ID（1 为“出境游”，2为“国内游”，3为“周边游”，4为 “当地游”，238为 “邮轮游”，0为搜索
@property (nonatomic, copy)  NSString * queryType;  //查询类型 =1代表查跟团，=2代表查自由行，=0代表查全部
@property (nonatomic, copy)  NSString * goDateCondition;  //日期条件  2014-09-08 08:08
@property (nonatomic, assign)  NSUInteger priceRangeID;   //价格范围（1:1-500、2:501-1000、3:1001-5000、4:5001-10000、5:10001-50000、6:50001以上）
@property (nonatomic, assign)  NSUInteger  dayRangeID;//出行天数范围ID(1:1-2天;2:3-5天;3:6-8天;4:8天以上)
@property (nonatomic, assign)  NSUInteger  orderBy;  //排序（1推荐热门，2价格升序，3销量降序，4推荐冷门，5价格降序，6，销售量升序）
@property (nonatomic, assign)  NSUInteger diamond; //等级

@property (nonatomic, copy)  NSString * preDestinationID;
@property (nonatomic, copy)  NSString * preDestination;
@property (nonatomic, copy)  NSString * destination; //目的地
@property (nonatomic, copy)  NSString * preDestinationSearchKeyword;

@property (nonatomic, strong)  NSArray * arrWithDestinationClass; //搜索扩展
@property (nonatomic, copy)  NSString * searchKeyword;    // 搜索字段
//@property (nonatomic, copy)  NSString * searchStr;
@property (nonatomic, strong)  UZCity * city;
@property (nonatomic, assign)  BOOL isSearch;  //是否是搜索
@property (nonatomic, assign)  BOOL isProductSearch;  //是否是根据产品编号进行搜索

@end
