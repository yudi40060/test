//
//  BaiDuAppSearch.h
//  AppSearch
//
//  Created by juqiang on 14-10-20.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BaiduAppsearchSchemeKey @"appsearch0013"

static NSMutableString * _sRelpurl;
static double _ts_time;

@interface BaiDuAppSearch : NSObject

+ (id)sharedInstance;
- (void)onClient :(NSString *)str;
- (void)onExit;

@end
