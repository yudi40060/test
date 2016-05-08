//
//  UZListPageDatePickerCell.h
//  UZai5.2
//
//  Created by uzai on 14-9-11.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltratePickerView.h"

@interface UZListPageDatePickerCell : UITableViewCell<SelectDateDelegate>

@property (nonatomic, strong)  FiltratePickerView *pickerView;
@property (nonatomic, strong)  NSDate * date;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic,copy) void (^onclik)(id data);
@property (nonatomic, copy)  NSString * goDateCondition;
-(void)ShowWithSelect:(void(^)(NSString *data))onclickBlock;
-(void)reloadWithDateStr:(NSString *)dateStr;
@end
