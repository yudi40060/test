//
//  UZListPageProductModel.m
//  Uzai
//
//  Created by leijian on 16/3/15.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import "UZListPageProductModel.h"

@implementation UZListPageProductModel

+(UZListPageProductModel *)getModelWithDic:(NSDictionary *)dic
{
    UZListPageProductModel *model = [[UZListPageProductModel alloc]init];
    model.cheapPrice = [dic[@"CheapPrice"] toString];
    model.diamond = [dic[@"Diamond"] toString];
    model.goCity = [dic[@"GoCity"] toString];
    model.goTravelNum = [dic[@"GoTravelNum"]toString];
    model.imageURL = [[dic[@"ImageURL"] toString] getZoomImageURLWithWidth:200];
    model.minPrice  = [dic[@"MinPrice"] toString];
    model.productCode  = [dic[@"ProductCode"] toString];
    model.productID  = [dic[@"ProductId"] toString];
    model.productName = [dic[@"ProductName"] toString];
    model.productType = [dic[@"ProductType"] toString];
    model.productURL = [dic[@"ProductURL"] toString];
    
    model.cheapTips = [NSMutableArray arrayWithCapacity:0];
    NSArray *cheapTipsTemp = dic[@"CheapTips"];
    if (cheapTipsTemp) {
        for (int i=0; i<cheapTipsTemp.count; i++) {
            NSString *cheapStr = cheapTipsTemp[i];
            if (model.cheapTips.count==2) {
                break;
            }
            if ([cheapStr isEqualToString:@"手机特惠"]&&![model.cheapTips containsObject:@"手机特惠"]) {
                [model.cheapTips addObject:cheapStr];
            }else if ([cheapStr rangeOfString:@"最高减"].location !=NSNotFound)
            {
                [model.cheapTips addObject:cheapStr];
            }
        }
    }
    return model;
}
+(NSArray *)getModelListWithArr:(NSArray *)arr
{
    NSMutableArray *arrTemp = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<arr.count; i++) {
        UZListPageProductModel *model = [UZListPageProductModel getModelWithDic:arr[i]];
        [arrTemp addObject:model];
    }
    
    return arrTemp;
}
@end
