//
//  UIViewController+HUD.h
//  XMSYS
//
//  Created by hjpraul on 14-3-7.
//  Copyright (c) 2014年 zhongjin. All rights reserved.
//


@interface UIViewController (HUD)

//HUD Methods
- (void)showLoadingWithMessage:(NSString *)message;

- (void)hideLoading;
////加载失败之后的提示
-(void)showLoadFailedWithBlock:(void (^)(void))FailedBlock;
-(void)showLoadFailedWithFrame:(CGRect)frame WithBlock:(void (^)(void))FailedBlock;
-(void)showNoMessage;
-(void)hideNoMessage;
-(void)showNoMessage:(UIImage *)noMessageImage withText:(NSString *)text;
@end
