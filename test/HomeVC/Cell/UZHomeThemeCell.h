//
//  UZHomeThemeCell.h
//  Uzai
//
//  Created by Uzai on 15/12/3.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZHomeThemeCell : UITableViewCell
-(void)dataSource:(NSArray *)dataList withthemeIndexBlock:(void(^)(NSUInteger index))themeIndexBlock;
@end
