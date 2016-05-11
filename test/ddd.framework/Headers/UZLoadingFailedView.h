//
//  UZLoadingFailedView.h
//  UZai5.2
//
//  Created by UZAI on 14-9-15.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZLoadingFailedView : UIView
+(void)showFailedImageViewWithImageBlock:(void(^)(void))ClickImageBlock withFrame:(CGRect)frame InView:(UIView *)view;
@end
