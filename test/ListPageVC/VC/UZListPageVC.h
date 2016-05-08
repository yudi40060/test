//
//  UZListPageVC.h
//  UZai5.2
//
//  Created by uzai on 14-9-10.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZBaseVC.h"
#import "UZListPageService.h"

@interface UZListPageVC : UZBaseVC

@property (nonatomic, strong)  UZListPageService * service;

-(id)initWithService:(UZListPageService *)service;
-(NSString *)travelGAStrCategory;
@end
