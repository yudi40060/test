//
//  UZRushBuyInfo.m
//  Uzai
//
//  Created by Uzai on 15/12/29.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZRushBuyInfo.h"

@implementation UZRushBuyInfo

@dynamic msTime;
@dynamic tmhType;
@dynamic msTimeEnd;
//@dynamic tmhList;
@dynamic index;
@dynamic tmhDatas;

+(UZRushBuyInfo *)getRushBuyInfo:(NSDictionary *)dict;
{
    UZRushBuyInfo *info=[UZRushBuyInfo createNew];
    info.msTime=[dict[@"MsTime"]toString];
    info.tmhType=[dict[@"TmhType"]toString];
    NSMutableArray *tempList=[NSMutableArray arrayWithArray:dict[@"TmhList"]];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"Index" ascending:YES], nil];
   
    [tempList sortUsingDescriptors:sortDescriptors];
    info.msTimeEnd=[dict[@"MsTimeEnd"]toString];
//    info.tmhList=tempList;
    info.tmhDatas = [NSKeyedArchiver archivedDataWithRootObject:tempList];
    return info;
}

+(void)saveData:(NSArray *)dataList
{
    [dataList enumerateObjectsUsingBlock:^(UZRushBuyInfo   *info, NSUInteger idx, BOOL * _Nonnull stop) {
        [UZRushBuyInfo save:^(NSError *error) {
            
        }];
    }];
}

+(BOOL)deleObj
{
    if ([UZRushBuyInfo deleteData:@"UZRushBuyInfo" withPredicate:@""]) {
        return YES;
    }
    return NO;
}


//var msTime:String!//最后一次秒杀的时间
//var tmhType:String!//0 无数据 1：样式1  2：样式2……
//var Wdsm:String!//尾单甩卖
//var zddh:String!//早定多惠
//var xsms:String!//限时秒杀图片
//var tjph:String!//特价优惠
//@property (nonatomic,strong) NSString *msTime;
//@property (nonatomic,strong) NSString *tmhType;
//@property (nonatomic,strong) NSString *Wdsm;
//@property (nonatomic,strong) NSString *zddh;
//@property (nonatomic,strong) NSString *xsms;
//@property (nonatomic,strong) NSString *tjph;
@end
