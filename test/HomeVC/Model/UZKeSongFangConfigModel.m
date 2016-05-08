//
//  UZKeSongFangConfigModel.m
//  UZai5.2
//
//  Created by uzai on 15/6/17.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

#import "UZKeSongFangConfigModel.h"

@implementation UZKeSongFangConfigModel

+(UZKeSongFangConfigModel *)getModelWithDic:(NSDictionary *)dic
{
    UZKeSongFangConfigModel *model = [UZKeSongFangConfigModel new];
    model.bannerPic = dic[@"BannerPic"];
    model.buttonText = dic[@"ButtonText"];
    model.intro = dic[@"Intro"];
    model.prizePicPic = dic[@"PrizePicPic"];
    
    return model;
}
@end
