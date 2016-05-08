//
//  UZKeSongFangConfigModel.h
//  UZai5.2
//
//  Created by uzai on 15/6/17.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZKeSongFangConfigModel : NSObject

@property (nonatomic, copy)  NSString * bannerPic;
@property (nonatomic, copy)  NSString * buttonText;
@property (nonatomic, copy)  NSString * intro;
@property (nonatomic, copy)  NSString * prizePicPic;

+(UZKeSongFangConfigModel *)getModelWithDic:(NSDictionary *)dic;
@end
