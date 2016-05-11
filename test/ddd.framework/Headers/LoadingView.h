//
//  LoadingView.h
//  XMSYS
//
//  Created by hjpraul on 14-3-7.
//  Copyright (c) 2014年 zhongjin. All rights reserved.
//

@interface LoadingView : UIView

+ (void)showLoadingMessage:(NSString *)message inView:(UIView *)view;

+ (void)hideInView:(UIView *)view animated:(BOOL)animated;
-(void)startAnimation;
-(void)stopAniation;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIImageView *bgImageView;
@end
