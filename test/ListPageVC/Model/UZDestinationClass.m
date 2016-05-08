//
//  UZDestinationClass.m
//  UZai5.2
//
//  Created by uzai on 14-9-25.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZDestinationClass.h"
#import "UZDestinationDTO.h"

@implementation UZDestinationClass
+(UZDestinationClass *)destinationClassWithDic:(NSDictionary *)dic
{
    UZDestinationClass *desClass=[[UZDestinationClass alloc]init];
    desClass.ID=dic[@"ID"];
    desClass.NavLinkName=dic[@"NavLinkName"];
    NSArray *arr=dic[@"DestinationDTO"];
    desClass.destinationDTO=[NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dicWithDTO in arr) {
        [desClass.destinationDTO addObject:[UZDestinationDTO DestinationDTOWithDict:dicWithDTO]];
    }
    return desClass;
}
@end
