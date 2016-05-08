//
//  UZHomeProductHeaderCell.m
//  Uzai
//
//  Created by Uzai on 15/12/4.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeProductHeaderCell.h"

@implementation UZHomeProductHeaderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"UZHomeProductHeaderCell" owner:self options:nil][0];
        CGFloat height=47*Main_Screen_Width/375;
        self.widthConstaints.constant=Main_Screen_Width/2-102/2;
        self.bottomConstaints.constant=height/2-20/2-10;
        self.leftConstaints.constant=0.5;
        [self updateConstraints];
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
