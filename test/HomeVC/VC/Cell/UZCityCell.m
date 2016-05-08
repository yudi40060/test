//
//  UZCityCell.m
//  UZai5.2
//
//  Created by UZAI on 14-9-5.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZCityCell.h"

@implementation UZCityCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
