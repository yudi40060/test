//
//  UZRushBuyInfo.h
//  Uzai
//
//  Created by Uzai on 15/12/29.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface UZRushBuyInfo : NSManagedObject

@property (nonatomic,retain) NSString *msTime;
@property (nonatomic,retain) NSString *tmhType;
//@property (nonatomic,retain) NSArray *tmhList;
@property (nonatomic,retain) NSString *index;
@property (nonatomic,retain) NSData *tmhDatas;
/**
 *  结束时间
 */
@property (nonatomic,retain) NSString *msTimeEnd;
+(BOOL)deleObj;
+(void)saveData:(NSArray *)dataList;
+(UZRushBuyInfo *)getRushBuyInfo:(NSDictionary *)dict;
@end
/*
 //var msTime:String!//最后一次秒杀的时间
 //var tmhType:String!//0 无数据 1：样式1  2：样式2……
 //var Wdsm:String!//尾单甩卖
 //var zddh:String!//早定多惠
 //var xsms:String!//限时秒杀图片
 //var tjph:String!//特价优惠
 */