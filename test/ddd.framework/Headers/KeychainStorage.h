//
//  KeychainStorage.h
//  XMSYS
//
//  Created by hjpraul on 14-3-6.
//  Copyright (c) 2014年 zhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainStorage : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end
