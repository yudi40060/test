//
//  UZCustomCell.m
//  UZai5.2
//
//  Created by UZAI on 14-9-15.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZCustomCell.h"

#import "UIColor+RGBString.h"
@interface UZCustomCell()


@property (weak, nonatomic) IBOutlet UIImageView *icon_MoreImage;
@end
@implementation UZCustomCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setDataTitleMessage:(NSString *)titleMessage
             withIndexPath:(NSIndexPath *)indexPath
            withPhoderList:(NSMutableArray *)phoderList
              withTextList:(NSMutableArray *)textList;

{
    if (indexPath.section==0&&indexPath.row==0) {
        [self.icon_MoreImage setHidden:YES];
    }
    
    
    self.textFiled.tag=indexPath.section;
    self.titleLabel.text=titleMessage;
    self.titleLabel.textColor=[UIColor ColorRGBWithString:@"#333333"];
    
    if ((indexPath.section>2&&indexPath.section<7)||indexPath.section==0||indexPath.section==2) {
        [self.textFiled setUserInteractionEnabled:NO];
    }
    else
    {
         [self.textFiled setUserInteractionEnabled:YES];
    }
    
    self.textFiled.textColor=[UIColor ColorRGBWithString:bgWithBlueTextColor];
    if (indexPath.section==1) {
        if ([[textList objectAtIndex:indexPath.section] length]) {
            self.textFiled.text=[textList objectAtIndex:indexPath.section];
        }
        else
        {
             self.textFiled.placeholder=[phoderList objectAtIndex:0];
        }
        [self.icon_MoreImage setHidden:YES];
    }
    else if (indexPath.section>6)
    {
        [self.icon_MoreImage setHidden:YES];
        if ([[textList objectAtIndex:indexPath.section] length]) {
            self.textFiled.text=[textList objectAtIndex:indexPath.section];
        }
        else
        {
            self.textFiled.placeholder=[phoderList objectAtIndex:indexPath.section-6];
        }
    }
    else
    {
         self.textFiled.text=[textList objectAtIndex:indexPath.section];
        [self.icon_MoreImage setHidden:NO];
    }
    if (indexPath.section==7||indexPath.section==8||indexPath.section==10) {
        self.textFiled.keyboardType=UIKeyboardTypeNumberPad;
    }
    else
        self.textFiled.keyboardType=UIKeyboardTypeDefault;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
