//
//  UZHomeSaleCell.h
//  Uzai
//
//  Created by Uzai on 15/12/3.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZRushBuyInfo.h"
@interface UZHomeSaleCell : UITableViewCell
-(void)datasource:(UZRushBuyInfo *)info withSaleIndexBlock:(void(^)(NSUInteger index))saleIndexBlock;
@end
