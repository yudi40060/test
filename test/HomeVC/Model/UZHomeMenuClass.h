//
//  UZHomeMenuClass.h
//  Uzai
//
//  Created by Uzai on 15/12/30.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface UZHomeMenuClass : NSObject
@property (nonatomic,strong) NSString *menuIndexType;
@property (nonatomic,strong) NSString *skipType;
@property (nonatomic,strong) NSString *skipDes;
@property (nonatomic,strong) NSString *skipURL;
@property (nonatomic,strong) NSString *imageURL;

+(UZHomeMenuClass *)menuClassWithDict:(NSDictionary *)dict;


+(NSMutableArray *)getMenuList:(NSArray *)dataList;

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