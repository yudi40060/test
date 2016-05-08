//
//  UZVisCountry.h
//  UZai5.2
//
//  Created by UZAI on 14-9-16.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZVisCountry : NSObject
/*       CountryAreaName = "\U4e9a\U6d32";
                                   CountryId = 11652;
                                   CountryName = "\U6cf0\U56fd";
                                   Logo = "http://mobile.uzai.com:8080/Visa/1/201305311328132901.png";
                                   PY = taiguo;
                                   VisaCountryID = 1;*/
@property (nonatomic,strong) NSString *CountryAreaName;
@property (nonatomic,strong) NSString *CountryId;
@property (nonatomic,strong) NSString *CountryName;
@property (nonatomic,strong) NSString *Logo;
@property (nonatomic,strong) NSString *PY;
@property (nonatomic,strong) NSString *VisaCountryID;

+(UZVisCountry *)visCountryWithDict:(NSDictionary *)dict;
@end
