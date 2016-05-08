//
//  UZCityRightView.h
//  Uzai
//
//  Created by Uzai on 16/1/15.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZCityRightView : UIView
-(void)datasource:(NSArray *)rightIndexlist withCitySelectIndex:(void(^)(NSUInteger index))citySelectIndex;
@end
