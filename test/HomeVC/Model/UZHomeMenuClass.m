//
//  UZHomeMenuClass.m
//  Uzai
//
//  Created by Uzai on 15/12/30.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeMenuClass.h"
#import "NSManagedObject+helper.h"
@implementation UZHomeMenuClass


+(UZHomeMenuClass *)menuClassWithDict:(NSDictionary *)dict;
{
    UZHomeMenuClass *homeClass=[[UZHomeMenuClass alloc]init];
    homeClass.menuIndexType=[dict[@"ServiceModelType"]toString];
    homeClass.skipType=[dict[@"skipType"]toString];
    homeClass.skipDes=[dict[@"skipDes"]toString];
    homeClass.skipURL=[dict[@"skipUrl"]toString];
    homeClass.imageURL=[dict[@"ImageURL"]toString];
    return homeClass;
}

+(NSMutableArray *)getMenuList:(NSArray *)dataList;
{
    NSMutableArray *menuList=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in dataList) {
        UZHomeMenuClass *homeClass=[UZHomeMenuClass menuClassWithDict:dict];
        [menuList addObject:homeClass];
    }
    return menuList;
}



@end
/*
 ServiceModelType	Int	Y	——	模块类型：
 签证 = 1,
 酒店 = 2,
 私家团 = 3,
 skipType	String	Y		跳转类型：
 活动 = 1,原生 = 5,
 skipDes	String	Y		跳转描述（分享描述）
 skipURL	String 	N		H5的跳转地址
 ImageURL	String 	Y		图片地址
 */