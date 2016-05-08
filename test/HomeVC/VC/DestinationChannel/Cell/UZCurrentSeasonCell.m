//
//  UZCurrentSeasonCell.m
//  Uzai
//
//  Created by Uzai-macMini on 16/1/5.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import "UZCurrentSeasonCell.h"

@implementation UZCurrentSeasonCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"UZCurrentSeasonCell" owner:nil options:nil][0];
        
        self.leftLineViewWidth.constant = (SCREEN_WIDTH-73-22)/2;
        self.leftLineViewHeight.constant = 0.5;
        self.rightLineViewWidth.constant = (SCREEN_WIDTH-73-22)/2;
        self.rightLineViewHeight.constant = 0.5;
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
