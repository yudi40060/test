//
//  UZDataListCell.h
//  UZai5.2
//
//  Created by UZAI on 14-9-15.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZDataListCell : UITableViewCell
-(void)setcontentText:(NSArray *)contentList withBlock:(void(^)(NSString *))buttonBlock;
+(CGFloat)rowOfHeight:(NSArray *)dataList;
@end
