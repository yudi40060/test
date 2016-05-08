//
//  UZPreDestination.h
//  UZai5.2
//
//  Created by UZAI on 14-9-4.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZPreDestination : NSObject
@property (nonatomic,strong) NSMutableArray *DestinationDTO;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *Name;

+(UZPreDestination *)destinationWithDict:(NSDictionary *)dict;



@end
