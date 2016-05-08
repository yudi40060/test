//
//  UZVisaCity.m
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZVisaCity.h"

@implementation UZVisaCity

+(UZVisaCity *)cityWithDict:(NSDictionary *)dict
{
    UZVisaCity *city=[[UZVisaCity alloc]init];
    city.ID=[dict[@"ID"] integerValue];
    city.Name=[NSString stringWithFormat:@"%@",dict[@"Name"]];

    return city;
}
@end
