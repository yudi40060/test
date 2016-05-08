//
//  UZVisaMessage.h
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZVisaMessage : NSObject

@property (nonatomic, copy)  NSString * ProductID;
@property (nonatomic, copy)  NSString * Type;
@property (nonatomic, copy)  NSString * Url;
@property (nonatomic, copy)  NSString * Name;
@property (nonatomic, copy)  NSString * WorkTime;
@property (nonatomic, copy)  NSString * VisaPrice;
@property (nonatomic, copy)  NSString * VisaArea;
@property (nonatomic, copy)  NSString * IsContainVisa;
+(UZVisaMessage *)visMessageWithDict:(NSDictionary *)dict;

@end
