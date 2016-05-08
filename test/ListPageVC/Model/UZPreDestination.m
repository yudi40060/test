//
//  UZPreDestination.m
//  UZai5.2
//
//  Created by UZAI on 14-9-4.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZPreDestination.h"

@implementation UZPreDestination
-(id)init
{
    self=[super init];
    if (self) {
        _DestinationDTO=[[NSMutableArray alloc]init];
    }
    return self;
}

+(UZPreDestination *)destinationWithDict:(NSDictionary *)dict;
{
    UZPreDestination *destiation=[[UZPreDestination alloc]init];
//    destiation.DestinationDTO=dict[@"DestinationDTO"];
     destiation.ID=[dict[@"ID"]toString];
     destiation.Name=[dict[@"NavLinkName"] toString];
    return destiation;
}
@end
/*
 @property (nonatomic,strong) NSArray *DestinationDTO;
 @property (nonatomic,strong) NSString *ID;
 @property (nonatomic,strong) NSString *Name;
 */