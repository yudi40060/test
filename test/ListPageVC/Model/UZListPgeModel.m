//
//  UZListPgeModel.m
//  UZai5.2
//
//  Created by uzai on 14-9-12.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZListPgeModel.h"

@implementation UZListPgeModel

-(instancetype)init
{
   self = [super init];
    if (self) {
        self.orderBy = 1; //默认推荐热门
        self.diamond = 0;
        self.travelClassID = @"0";
    }
    return self;
}
@end
