//
//  UZQRModel.h
//  UZai5.2
//
//  Created by uzai on 15/6/17.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZQRModel : NSObject

@property (nonatomic, copy)  NSString * buttonLink;
@property (nonatomic, copy)  NSString * buttonText;
@property (nonatomic, copy)  NSString * coverUrl;
@property (nonatomic, copy)  NSString * state;
@property (nonatomic, copy)  NSString * addTime;
@property (nonatomic, copy)  NSString * expireTime;
@property (nonatomic, copy)  NSString * QRCodeURL;
@property (nonatomic, copy)  NSString * assistNumber;

+(UZQRModel *)getModelWithDic:(NSDictionary *)dic;
//state
//领取且已用 = 1,
//领取且可用 = 2,
//领取且过期 = 3,
//领取成功 = 4,
//活动已结束 = 5,
//老用户不可领取=6
//设备已经领取过=7


@end
