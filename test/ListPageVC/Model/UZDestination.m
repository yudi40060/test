//
//  UZDestination.m
//  UZai5.2
//
//  Created by UZAI on 14-9-4.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZDestination.h"

@implementation UZDestination
+(UZDestination *)destinationWithDict:(NSDictionary *)dict
{
    UZDestination *destionation=[[UZDestination alloc]init];
    destionation.ID=[dict[@"ID"] toString];
    destionation.LastEditTime=[dict[@"LastEditTime"] toString];
    destionation.MobileNavIconURL=[dict[@"MobileNavIconURL"] toString];
    destionation.MobileSearchKeyWord=[dict[@"MobileSearchKeyWord"] toString];
    destionation.NavLinkName=[dict[@"NavLinkName"] toString];
    destionation.NavPicUrl=[dict[@"NavPicUrl"] toString];
    destionation.NavTypeName=[dict[@"NavTypeName"] toString];
    destionation.ParentNavLinkID=[dict[@"ParentNavLinkID"] toString];
    return destionation;
}
@end
/*
 @property (nonatomic,strong) NSString *ID;
 @property (nonatomic,strong) NSString *LastEditTime;
 @property (nonatomic,strong) NSString *MobileNavIconURL;
 @property (nonatomic,strong) NSString *MobileSearchKeyWord;
 @property (nonatomic,strong) NSString *NavLinkName;
 @property (nonatomic,strong) NSString *NavPicUrl;
 @property (nonatomic,strong) NSString *NavTypeName;
 @property (nonatomic,strong) NSString *ParentNavLinkID;
 */


/*
 @property (nonatomic,strong) NSString *ID;
 @property (nonatomic,strong) NSString *ProductName;
 @property (nonatomic,strong) NSString *ClassName;
 @property (nonatomic,strong) NSString *ClassID;
 @property (nonatomic,strong) NSString *PictureURL;
 @property (nonatomic,strong) NSString *TreeName;
 @property (nonatomic,strong) NSString *SearchKeyWord;
 */