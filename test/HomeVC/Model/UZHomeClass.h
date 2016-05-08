//
//  UZHomeClass.h
//  Uzai
//
//  Created by Uzai on 15/12/17.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZHomeSubClass: NSObject
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
@property (nonatomic,strong) NSString *Fields3;//相当于之前的travelClassID(1为出境游，2为国内游...)
@property (nonatomic,strong) NSString *StartCity;
+(UZHomeSubClass *)homeSubClassWithDict:(NSDictionary *)dict;
@end

/*
 ID	Int	N	——	父类导航对象实体
 NavLinkName	String	Y		导航名称
 NavLinkURL	String	Y		导航URL地址
 ParentNavLinkID	Int 	Y		父ID
 NavTypeName	String	Y		导航类型名称
 sortID	Int	Y		排序索引
 NavPicUrl	String	Y		自定义图片地址
 MobileNavIconURL	String	Y		图标地址
 MobileSearchKeyWord	String	Y		关键字地址
 Fields1	String 	Y		是否热门
 Fields2	String	N		导航的关键字：（样式如下）
 “1月/泰国，2月/普吉岛，三亚/日本”
 */
@interface UZHomeClass : NSObject
@property (nonatomic,strong) UZHomeSubClass *subClass;
@property (nonatomic,strong) NSMutableArray *navLink;

+(NSMutableArray *)getHomeClassList:(NSArray *)keyDataList;;
@end
