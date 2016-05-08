//
//  UZVisCountry.m
//  UZai5.2
//
//  Created by UZAI on 14-9-16.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZVisCountry.h"

@implementation UZVisCountry
/*
 @property (nonatomic,strong) NSString *CountryAreaName;
 @property (nonatomic,strong) NSString *CountryId;
 @property (nonatomic,strong) NSString *CountryName;
 @property (nonatomic,strong) NSString *Logo;
 @property (nonatomic,strong) NSString *PY;
 @property (nonatomic,strong) NSString *VisaCountryID;
 */
+(UZVisCountry *)visCountryWithDict:(NSDictionary *)dict
{
    UZVisCountry *country=[[UZVisCountry alloc]init];
    country.CountryAreaName=[dict[@"CountryAreaName"] toString];
    country.CountryId=[dict[@"CountryId"] toString];
    country.CountryName=[dict[@"CountryName"] toString];
    country.Logo=[dict[@"Logo"] toString];
    country.PY=[dict[@"PY"] toString];
    country.VisaCountryID=[dict[@"VisaCountryID"] toString];
    return country;
}
@end
