//
//  UZDestinationDTO.h
//  UZai5.2
//
//  Created by uzai on 14-9-25.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZDestinationDTO : NSObject

@property (nonatomic, copy)  NSString * ID;
@property (nonatomic, copy)  NSString * LastEditTime;
@property (nonatomic, copy)  NSString * MobileNavIconURL;
@property (nonatomic, copy)  NSString * MobileSearchKeyWord;
@property (nonatomic, copy)  NSString * NavLinkName;
@property (nonatomic, copy)  NSString * NavPicUrl;
@property (nonatomic, copy)  NSString * NavTypeName;
@property (nonatomic, copy)  NSString * ParentNavLinkID;
+(UZDestinationDTO *)DestinationDTOWithDict:(NSDictionary *)dict;
@end

/**
ID = 0;
LastEditTime = "/Date(-62135596800000)/";
MobileNavIconURL = "<null>";
MobileSearchKeyWord = "\U7279\U7acb\U5c14";
NavLinkName = "\U7279\U7acb\U5c14";
NavPicUrl = "<null>";
NavTypeName = "<null>";
ParentNavLinkID = 0;
**/