//
//  ChineseInclude.h
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
//判断内容中是否含有汉字
@interface ChineseInclude : NSObject
+ (BOOL)isIncludeChineseInString:(NSString*)str;
@end
