//
//  UZListPageProductModel.h
//  Uzai
//
//  Created by leijian on 16/3/15.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZListPageProductModel : NSObject
@property (nonatomic,copy) NSString *productID;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *productURL;
@property (nonatomic,copy) NSString *diamond;
@property (nonatomic,copy) NSString *productCode;
@property (nonatomic,copy) NSString *productType;
@property (nonatomic,copy) NSString *goCity;
@property (nonatomic,copy) NSString *minPrice;
@property (nonatomic,copy) NSString *cheapPrice;
@property (nonatomic,strong) NSMutableArray *cheapTips;
@property (nonatomic,copy) NSString *imageURL;
@property (nonatomic,copy) NSString *goTravelNum;

@property(nonatomic,assign) BOOL isRead;
+(UZListPageProductModel *)getModelWithDic:(NSDictionary *)dic;
+(NSArray *)getModelListWithArr:(NSArray *)arr;
//ProductId	int 	空	产品ID
//ProductName	String 	空	产品名称
//ProductURL	String	空	产品地址
//Diamond、	Int	0	产品等级
//ProductCode	String 	空	优惠金额
//ProductType	String	空	跟团游，自由行，邮轮游
//GoCity	String	0 	出发城市
//MinPrice	String	0	悠哉价
//CheapPrice	String	0	APP特惠价
//CheapTips	List<string>	空	产品标签
//ImageURL	String	空	主显图片
//GoTravelNum	Int	0	出行人数
@end
