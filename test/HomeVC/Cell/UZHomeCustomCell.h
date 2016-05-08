//
//  UZHomeCustomCell.h
//  Uzai
//
//  Created by Uzai on 15/12/4.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickCustomBlock)(void);
@interface UZHomeCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *customBtn;
@property (nonatomic,strong) clickCustomBlock customBlock;
@end
