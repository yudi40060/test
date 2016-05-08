//
//  UZHomeProductCell.m
//  Uzai
//
//  Created by Uzai on 15/12/4.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeProductCell.h"
#import "UZProduct.h"
#import "UZPriceLable.h"
@interface UZHomeProductCell()
@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;
@property (weak, nonatomic) IBOutlet UZPriceLable *originalPriceLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneConstaints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstaints;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabelText;
@property (weak, nonatomic) IBOutlet UILabel *deleteNumerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originalPriceConstaints;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@end
@implementation UZHomeProductCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"UZHomeProductCell" owner:self options:nil][0];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    // Fix the bug in iOS7 - initial constraints warning
  self.contentView.bounds = [UIScreen mainScreen].bounds;
}


-(void)setLabelTextPrice:(NSString *)originalPrice minPrice:(NSString *)minPrice
{
    self.minPriceLabel.attributedText=[NSString getUnitAttributedstr:@"￥" unit:minPrice textColor:[UIColor ColorRGBWithString:bgWithTextColor] ploderText:@""];
    CGSize size=[self.minPriceLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 25)];
    self.widthConstaints.constant=size.width+5;
   
    self.originalPriceLbl.text=[NSString stringWithFormat:@"￥%@",originalPrice];
     CGSize size1=[self.originalPriceLbl sizeThatFits:CGSizeMake(CGFLOAT_MAX, 20)];
    self.originalPriceConstaints.constant=size1.width+5;
    self.originalPriceLbl.lineType=LineTypeMiddle;
    self.originalPriceLbl.lineColor=self.originalPriceLbl.textColor;
    if ([originalPrice floatValue]-[minPrice floatValue]>0) {
        self.deleteNumerLabel.textColor=[UIColor ColorRGBWithString:bgWithTextColor];
        ViewBorderRadius(self.deleteNumerLabel, 3, 0.5, [UIColor ColorRGBWithString:bgWithTextColor]);
        self.deleteNumerLabel.text=[NSString stringWithFormat:@"减￥%.0f",[originalPrice floatValue]-[minPrice floatValue]];
        self.deleteNumerLabel.hidden=false;
    }else
    {
        self.deleteNumerLabel.hidden=true;
    }
    if ([originalPrice isEqualToString:minPrice]) {
        self.originalPriceLbl.hidden=true;
    }else
    {
        self.originalPriceLbl.hidden=false;
    }
}

-(void)dataSource:(UZProduct *)product;
{
    self.productNameLabel.text=product.productName;
    [self setLabelTextPrice:product.MaxPrice minPrice:product.minPrice];
    if ([product.MobileCheapPrice floatValue]>0) {
        self.phoneConstaints.constant=64;
        ViewBorderRadius(self.phoneLabelText, 3, 0.5, [UIColor ColorRGBWithString:@"#f93868"]);
        self.phoneLabelText.textColor=[UIColor ColorRGBWithString:@"#f93868"];
        self.phoneLabelText.hidden=false;
    }else
    {
        self.phoneConstaints.constant=0;
        [self updateConstraints];//更新约束
        self.phoneLabelText.hidden=true;
    }
    __weak UZHomeProductCell *weakSelf=self;
    [UZTheadCommon enqueueMainThreadPoolWithDelay:^{
        [weakSelf loadImage:product.PicUrl];
    } delay:0.5];
}

-(void)loadImage:(NSString *)imageUrl
{
    [self.imgView setImageWithUrlStr:[imageUrl getZoomImageURLWithWidth:Main_Screen_Width] withplaceholder:@""];
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, 216*Main_Screen_Width/375+70);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
