//
//  UZDestination.h
//  UZai5.2
//
//  Created by UZAI on 14-9-4.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZDestination : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *LastEditTime;
@property (nonatomic,strong) NSString *MobileNavIconURL;
@property (nonatomic,strong) NSString *MobileSearchKeyWord;
@property (nonatomic,strong) NSString *NavLinkName;
@property (nonatomic,strong) NSString *NavPicUrl;
@property (nonatomic,strong) NSString *NavTypeName;
@property (nonatomic,strong) NSString *ParentNavLinkID;


+(UZDestination *)destinationWithDict:(NSDictionary *)dict;
@end
/*
 ID	Int		——	产品ID
 ProductName	String		——	产品名字
 ClassName	String			父类的名字，如云南的父类名字为国内游
 ClassID	Int			父类的ID，如云南的父类ID为国内游ID
 PictureURL	String			产品图片地址
 TreeName	String	N		产品景点名字
 SearchKeyWord	String			搜索关键字
 */