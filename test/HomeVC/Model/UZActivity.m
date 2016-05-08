//
//  UZActivity.m
//  UZai5.2
//
//  Created by UZAI on 14-9-4.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZActivity.h"
#import "NSManagedObject+helper.h"

@implementation UZActivity

+(UZActivity *)activityWithDict:(NSDictionary *)dict
{
    UZActivity *activeity=[[UZActivity alloc] init];
    activeity.activityUrl=[dict[@"ActivityUrl"] toString];
    activeity.hotTree=[dict[@"HotTree"] toString];
    activeity.iD=[dict[@"ID"]toString];//3
    activeity.name=[dict[@"Name"]toString];
    activeity.productID=[dict[@"ProductID"]toString];
    activeity.topicsID=[dict[@"TopicsID"]toString];
    activeity.topicsImgUrlHorizontal=[dict[@"TopicsImgUrlHorizontal"] toString];//6
    activeity.topicsName=[dict[@"TopicsName"] toString];
    activeity.topicsImgUrl=[[dict objectForKey:@"TopicsImgUrl"] toString];
    activeity.type=[dict[@"Type"] toString];//9
    activeity.imgUrl=[dict[@"ImgUrl"] toString];
    activeity.userAlreadyShare=[dict[@"UserAlreadyShare"] toString];
    activeity.uzaiTravelClassID=[dict[@"UzaiTravelClassID"] toString];
    activeity.isShare=[dict[@"IsShare"] toString];
    activeity.shareContent=[dict[@"ShareContent"] toString];
    activeity.keyword=[dict[@"Keyword"]toString];
    activeity.sort=[dict[@"Sort"]toString];
    activeity.tagIndex=[dict[@"TagIndex"]toString];
    return activeity;
}

+(NSMutableArray *)arrayListWithKeyList:(NSArray *)keyDataList;
{
    NSMutableArray *dataList=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in keyDataList) {
        UZActivity *activeity=[UZActivity activityWithDict:dict];
        [dataList addObject:activeity];
    }
    return dataList;
}

@end
