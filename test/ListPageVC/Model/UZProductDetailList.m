//
//  UZProductDetailList.m
//  UZai5.2
//
//  Created by UZAI on 14-9-5.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZProductDetailList.h"

@implementation UZProductDetailList
+(UZProductDetailList *)productListWithDict:(NSDictionary *)dict
{
    UZProductDetailList *productList=[[UZProductDetailList alloc]init];
    
    productList.ID=[dict[@"ID"] toString];
    productList.ProductName=[dict[@"ProductName"] toString];
    productList.Diamond=[dict[@"Diamond"] toString];
    productList.ProductCode=[dict[@"ProductCode"] toString];
    productList.Price=[dict[@"Price"] toString];
    productList.SavePrice=[dict[@"SavePrice"] toString];
    productList.BackCash=[dict[@"BackCash"] toString];
    productList.MobileCheap=[dict[@"MobileCheap"] toString];
    productList.Days=[dict[@"Days"] toString];
    productList.ProductURL=[dict[@"ProductURL"] toString];
    productList.ImgUrl=[dict[@"ImgUrl"] toString];
    productList.IsSpecialOffer=[dict[@"IsSpecialOffer"] toString];
    
    productList.GoTravelNum=[dict[@"GoTravelNum"] toString];
    productList.GoDate=[dict[@"GoDate"] toString];
    productList.UzaiTravelClassID=[dict[@"UzaiTravelClassID"] toString];
    productList.StartCity=[dict[@"StartCity"]toString];
    productList.IsPraise = [dict[@"IsPraise"]toString];
    productList.Tag = dict[@"Tag"];
    
    productList.isRead = NO;
    return productList;
}
@end
/*
 @property (nonatomic,strong) NSString *ID;
 @property (nonatomic,strong) NSString *ProductName;
 @property (nonatomic,strong) NSString *ProductCode;
 @property (nonatomic,strong) NSString *Price;
 @property (nonatomic,strong) NSString *SavePrice;
 @property (nonatomic,strong) NSString *BackCash;
 @property (nonatomic,strong) NSString *MobileCheap;
 @property (nonatomic,strong) NSString *Days;
 @property (nonatomic,strong) NSString *ProductURL;
 @property (nonatomic,strong) NSString *ImgUrl;
 @property (nonatomic,strong) NSString *IsSpecialOffer;
 
 @property (nonatomic,strong) NSString *GoTravelNum;
 @property (nonatomic,strong) NSString *GoDate;
 @property (nonatomic,strong) NSString *UzaiTravelClassID;
 */