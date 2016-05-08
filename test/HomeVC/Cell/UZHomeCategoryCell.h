//
//  UZHomeCategoryCell.h
//  Uzai
//
//  Created by Uzai on 15/12/2.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZHomeCategoryCell : UITableViewCell
@property (nonatomic,strong) void (^homeCategoryBlockIndex)(NSUInteger index);

-(void)dataSource:(NSArray *)mentList cateGoryBlock:(void(^)(NSUInteger index))categroyBlock;
@end
