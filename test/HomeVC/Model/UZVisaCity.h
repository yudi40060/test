//
//  UZVisaCity.h
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZVisaCity : NSObject
@property (nonatomic,assign) NSUInteger ID;
@property (nonatomic,strong) NSString *Name;

+(UZVisaCity *)cityWithDict:(NSDictionary *)dict;
@end
