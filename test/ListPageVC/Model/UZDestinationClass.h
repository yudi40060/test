//
//  UZDestinationClass.h
//  UZai5.2
//
//  Created by uzai on 14-9-25.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZDestinationClass : NSObject
@property (nonatomic, strong)  NSMutableArray * destinationDTO;
@property (nonatomic, copy)  NSString * ID;
@property (nonatomic, strong)  NSString * NavLinkName;
+(UZDestinationClass *)destinationClassWithDic:(NSDictionary *)dic;
@end
