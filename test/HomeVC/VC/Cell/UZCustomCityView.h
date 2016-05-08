//
//  UZCustomCityView.h
//  UZai5.2
//
//  Created by UZAI on 14-9-19.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZCustomCityView : UIView
- (id)initWithFrame:(CGRect)frame withSelectBlock:(void(^)(NSString *cityMessage))selectBlock  withSearchStr:(NSString *)searchStr;
@end
