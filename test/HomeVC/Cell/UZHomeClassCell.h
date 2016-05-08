//
//  UZHomeClassCell.h
//  Uzai
//
//  Created by Uzai on 15/12/2.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickClassIndex)(NSUInteger);
@interface UZHomeClassCell : UITableViewCell
@property (nonatomic,strong) clickClassIndex classIndexBlock;
-(void)datasourceWithData:(NSArray *)dataList
           withclassBlock:(clickClassIndex)classBlock;
@end
