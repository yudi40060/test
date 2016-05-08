//
//  UZProductDetailList.h
//  UZai5.2
//
//  Created by UZAI on 14-9-5.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>
//产品列表
@interface UZProductDetailList : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *ProductName;
@property (nonatomic,strong) NSString *ProductCode;
@property (nonatomic,strong) NSString *Price;
@property (nonatomic,copy) NSString *SavePrice;
@property (nonatomic,strong) NSString *BackCash;
@property (nonatomic,strong) NSString *MobileCheap;
@property (nonatomic,strong) NSString *Days;
@property (nonatomic,strong) NSString *ProductURL;
@property (nonatomic,strong) NSString *ImgUrl;
@property (nonatomic,strong) NSString *IsSpecialOffer;
@property (nonatomic, strong)  NSString * Diamond;

@property (nonatomic,strong) NSString *GoTravelNum;
@property (nonatomic,strong) NSString *GoDate;
@property (nonatomic,strong) NSString *UzaiTravelClassID;
@property (nonatomic, strong)  NSString  * StartCity;
@property (nonatomic, strong)  NSString * IsPraise;
@property (nonatomic, strong)  NSArray * Tag;

@property (nonatomic, assign)  BOOL isRead;
+(UZProductDetailList *)productListWithDict:(NSDictionary *)dict;
@end
/*
 ID	 Int	Y	——	线路ID
 ProductName	String	Y	——	线路名称
 ProductCode	String	N	——	编号
 Price	String	N	——	价格
 SavePrice	String	N	——	减价价格
 BackCash	String	N	——	返现
 MobileCheap	String	N	——	手机优惠信息
 Days	Int	N	——	天数
 ProductURL	String	N	——	链接
 ImgUrl	String	N	——	图片链接
 IsSpecialOffer	Int	N	——	是否特殊
 GoTravelNum	String	N	——	已经出行人数
 GoDate	String	N	——	出发日期
 UzaiTravelClassID	String	N	——	线路类型
 */