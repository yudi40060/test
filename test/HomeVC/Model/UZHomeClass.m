//
//  UZHomeClass.m
//  Uzai
//
//  Created by Uzai on 15/12/17.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeClass.h"
@implementation UZHomeSubClass

+(UZHomeSubClass *)homeSubClassWithDict:(NSDictionary *)dict
{
    UZHomeSubClass *subClass=[[UZHomeSubClass alloc]init];
    subClass.ID=[dict[@"ID"]toString];
    subClass.NavLinkName=[dict[@"NavLinkName"]toString];
    subClass.NavLinkURL=[dict[@"NavLinkURL"]toString];//3
    subClass.ParentNavLinkID=[dict[@"ParentNavLinkID"]toString];
    subClass.NavTypeName=[dict[@"NavTypeName"]toString];
    subClass.sortID=[dict[@"sortID"]toString];//6
    subClass.NavPicUrl=[dict[@"NavPicUrl"]toString];
    subClass.MobileNavIconURL=[dict[@"MobileNavIconURL"]toString];
    subClass.MobileSearchKeyWord=[dict[@"MobileSearchKeyWord"]toString];//9
    subClass.Fields1=[dict[@"Fields1"]toString];
    subClass.Fields2=[dict[@"Fields2"]toString];
    subClass.Fields3 = [dict[@"Fields3"]toString];
    subClass.StartCity=[dict[@"StartCity"]toString];
    return subClass;
}
@end
/*
 @property (nonatomic,strong) NSString *ID;
 @property (nonatomic,strong) NSString *NavLinkName;
 @property (nonatomic,strong) NSString *NavLinkURL;
 @property (nonatomic,strong) NSString *ParentNavLinkID;
 @property (nonatomic,strong) NSString *NavTypeName;
 @property (nonatomic,strong) NSString *sortID;
 @property (nonatomic,strong) NSString *NavPicUrl;
 @property (nonatomic,strong) NSString *MobileNavIconURL;
 @property (nonatomic,strong) NSString *MobileSearchKeyWord;
 @property (nonatomic,strong) NSString *Fields1;
 @property (nonatomic,strong) NSString *Fields2;
 */
@implementation UZHomeClass
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.navLink=[[NSMutableArray alloc]init];
    }
    return self;
}
+(UZHomeClass *)homeClassWithDict:(NSDictionary *)dict
{
    UZHomeClass *homeClass=[[UZHomeClass alloc]init];
    homeClass.subClass=[UZHomeSubClass homeSubClassWithDict:[dict objectForKey:@"ParentsNavLink"]];
    for (NSDictionary *dict1 in dict[@"NavLink"]) {
        UZHomeSubClass *subClass=[UZHomeSubClass homeSubClassWithDict:dict1];
        [homeClass.navLink addObject:subClass];
    }
    return homeClass;
}

+(NSMutableArray *)getHomeClassList:(NSArray *)keyDataList;
{
    NSMutableArray *homeClassList=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in keyDataList) {
        UZHomeClass *class1=[UZHomeClass homeClassWithDict:dict];
        [homeClassList addObject:class1];
    }
    return homeClassList;
}

@end
