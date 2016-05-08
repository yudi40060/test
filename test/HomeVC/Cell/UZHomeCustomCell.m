//
//  UZHomeCustomCell.m
//  Uzai
//
//  Created by Uzai on 15/12/4.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeCustomCell.h"

@implementation UZHomeCustomCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"UZHomeCustomCell" owner:self options:nil][0];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    ViewRadius(self.customBtn, 4.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ClickCustomBtn:(id)sender {
    BLOCK_SAFE(self.customBlock)();
}

-(void)dealloc
{
    self.customBtn=nil;
}
@end
