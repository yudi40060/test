//
//  UZQRModel.m
//  UZai5.2
//
//  Created by uzai on 15/6/17.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

#import "UZQRModel.h"

@implementation UZQRModel

+(UZQRModel *)getModelWithDic:(NSDictionary *)dic
{
    UZQRModel *model = [UZQRModel new];
    model.buttonLink = dic[@"ButtonLink"];
    model.buttonText = dic[@"ButtonText"];
    model.coverUrl = dic[@"CoverUrl"];
    model.state = [dic[@"State"] toString];
    
    model.addTime = dic[@"QRCode"][@"AddTime"];
    model.expireTime = dic[@"QRCode"][@"ExpireTime"];
    model.QRCodeURL = dic[@"QRCode"][@"QRCodeURL"];
    model.assistNumber = dic[@"QRCode"][@"AssistNumber"];
    
    return model;
}
@end
