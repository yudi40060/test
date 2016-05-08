//
//  UZDestinationDTO.m
//  UZai5.2
//
//  Created by uzai on 14-9-25.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZDestinationDTO.h"

@implementation UZDestinationDTO

+(UZDestinationDTO *)DestinationDTOWithDict:(NSDictionary *)dict
{
    UZDestinationDTO *des=[[UZDestinationDTO alloc]init];
    des.ID=dict[@"ID"];
    des.LastEditTime=[NSString stringWithFormat:@"%@",dict[@"LastEditTime"]];
    des.MobileNavIconURL=[NSString stringWithFormat:@"%@",dict[@"MobileNavIconURL"]];
    des.MobileSearchKeyWord=[NSString stringWithFormat:@"%@",dict[@"MobileSearchKeyWord"]];
    des.NavLinkName=[NSString stringWithFormat:@"%@",dict[@"NavLinkName"]];
    des.NavPicUrl=[NSString stringWithFormat:@"%@",dict[@"NavPicUrl"]];
    des.NavTypeName=[NSString stringWithFormat:@"%@",dict[@"NavTypeName"]];
    des.ParentNavLinkID=[NSString stringWithFormat:@"%@",dict[@"ParentNavLinkID"]];
    
    return des;
}
@end
