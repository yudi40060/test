//
//  Global.h
//  bbb
//
//  Created by 于迪 on 16/5/10.
//  Copyright © 2016年 yudi. All rights reserved.
//

#ifndef Global_h
#define Global_h

#define bgWithTextColor @"#f93868"//背景以及颜色的字体(众信红)
#define bg33Color [UIColor ColorRGBWithString:@"#333333"]

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 客户端版本号
#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 判断是否是iOS7
#define isIOS7Above ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)
//判断当前是否是iOS8
#define isIOS8Above ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height
//alert 提示框
#define alertMessage(Message)\
UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:Message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];
// 安全调用Block的方法
#undef	BLOCK_SAFE
#define BLOCK_SAFE(block)           if(block)block

#import "UIColor+RGBString.h"

#endif /* Global_h */
