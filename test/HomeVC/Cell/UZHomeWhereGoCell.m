//
//  UZHomeWhereGoCell.m
//  Uzai
//
//  Created by Uzai on 15/12/4.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeWhereGoCell.h"

@implementation UZHomeWhereGoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"UZHomeWhereGoCell" owner:self options:nil][0];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)datasource:(UZHomeSubClass *)homeClass;
{
    [self.imgView setImageWithUrlStr:homeClass.MobileNavIconURL withplaceholder:@""];
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width,10+142*Main_Screen_Width/375);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
