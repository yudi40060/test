//
//  UZVisCountryList.m
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZVisCountryList.h"

@implementation UZVisCountryList
+(UZVisCountryList *)visCountryListWithDict:(NSDictionary *)dict
{
 
    UZVisCountryList *countryList=[[UZVisCountryList alloc]init];
    countryList.Key=dict[@"Key"];
    NSArray *arr=dict[@"Value"];
    NSMutableArray *tempArr=[NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in arr) {
        UZVisCountry *country=[UZVisCountry visCountryWithDict:dic];
        [tempArr addObject:country];
    }
    countryList.countryList=tempArr;
    return countryList;
}
@end
