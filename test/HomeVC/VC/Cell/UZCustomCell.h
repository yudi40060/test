//
//  UZCustomCell.h
//  UZai5.2
//
//  Created by UZAI on 14-9-15.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
-(void)setDataTitleMessage:(NSString *)titleMessage
             withIndexPath:(NSIndexPath *)indexPath
            withPhoderList:(NSMutableArray *)phoderList
              withTextList:(NSMutableArray *)textList;

@end
