//
//  UZVisCountryList.h
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UZVisCountry.h"

@interface UZVisCountryList : NSObject

@property (nonatomic, copy)  NSString * Key;   //字母
@property (nonatomic, strong)  NSMutableArray * countryList;

+(UZVisCountryList *)visCountryListWithDict:(NSDictionary *)dict;
@end
