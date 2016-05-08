//
//  UZVisaListCell.h
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZVisaListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblVisaArea;
@property (weak, nonatomic) IBOutlet UIImageView *imageType;

@end
