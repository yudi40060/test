//
//  UZListPageCell.m
//  UZai5.2
//
//  Created by uzai on 14-9-10.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZListPageCell.h"
#import "UIColor+RGBString.h"

@implementation UZListPageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self=[[[NSBundle mainBundle]loadNibNamed:@"UZListPageCell" owner:nil options:nil] objectAtIndex:0];
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

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.imageProduct.layer.cornerRadius=2;
    self.imageProduct.layer.masksToBounds = YES;
}
-(void)setData1:(UZListPageProductModel *)productModel
{
    [self.imageProduct setImageWithUrlStr:productModel.imageURL placeholderImage:nil];
    self.lblName.textColor = [UIColor ColorRGBWithString:productModel.isRead?@"#888888":@"#333333"];
    if ([productModel.diamond integerValue]==0) {
        self.lblDiamond.hidden=YES;
        self.imageDiamondBg.hidden=YES;
    }else
    {
        self.lblDiamond.hidden=NO;
        self.imageDiamondBg.hidden=NO;
        self.lblDiamond.text = [NSString stringWithFormat:@"%ld钻",(long)[productModel.diamond integerValue]];
    }
    self.lblName.text = productModel.productName;
    self.lblPrice.attributedText = [NSString getListPagePriceWithPrice:productModel.cheapPrice];
    self.lblGoTravelNum.text=[productModel.goTravelNum integerValue]==0 ? @"" : [NSString stringWithFormat:@"%@人出行",productModel.goTravelNum];
    if (productModel.cheapTips.count==0) {
        self.lblSavePrice.hidden = YES;
        self.lblMobileCheap.hidden = YES;
    }else
    {
        if (productModel.cheapTips.count>=2) {
            self.lblMobileCheap.hidden = NO;
            self.lblSavePrice.hidden = NO;
            for (int i=0; i<productModel.cheapTips.count; i++) {
                NSString *str = productModel.cheapTips[i];
                if ([str isEqualToString:@"手机特惠"]) {
                    self.lblMobileCheap.text = str;
                }else
                {
                    self.lblSavePrice.text = str;
                }
            }
            [self setRedStlyeWithLabel:self.lblSavePrice];
            [self setBlueStyleWithLabel:self.lblMobileCheap];
        }else
        {
            NSString *str = productModel.cheapTips[0];
            self.lblMobileCheap.hidden=YES;
            self.lblSavePrice.hidden=NO;
            if ([str isEqualToString:@"手机特惠"]) {
                self.lblSavePrice.text = str;
                 [self setBlueStyleWithLabel:self.lblSavePrice];
            }else
            {
                self.lblSavePrice.text = str;
                 [self setRedStlyeWithLabel:self.lblSavePrice];
            }
        }
        
        if(self.lblSavePrice.hidden == NO)
        {
            NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.lblSavePrice.font,NSFontAttributeName,nil];
            CGSize  actualsize =[self.lblSavePrice.text boundingRectWithSize:CGSizeMake(120,21) options:NSStringDrawingTruncatesLastVisibleLine  attributes:tdic context:nil].size;
            CGRect frame=self.lblSavePrice.frame;
            actualsize.height=21;
            actualsize.width+=10;
            frame.size=actualsize;
            [self.lblSavePrice sizeToFit];
            self.lblSavePrice.frame=frame;
            
            CGRect frame1 = self.lblMobileCheap.frame;
            if(self.lblSavePrice.hidden == NO)
            {
                frame1.origin.x = X(self.lblSavePrice) + actualsize.width + 6;
            }else
            {
                frame1.origin.x = 120;
            }
            self.lblMobileCheap.frame = frame1;
        }
        
    }
    
}
-(void)setData:(UZProductDetailList *)productModel
{
    [self.imageProduct setImageWithUrlStr:productModel.ImgUrl withplaceholder:nil];
    self.lblName.textColor = [UIColor ColorRGBWithString:productModel.isRead?@"#888888":@"#333333"];
    if ([productModel.Diamond integerValue]==0) {
        self.lblDiamond.hidden=YES;
        self.imageDiamondBg.hidden=YES;
    }else
    {
        self.lblDiamond.hidden=NO;
        self.imageDiamondBg.hidden=NO;
        self.lblDiamond.text = [NSString stringWithFormat:@"%ld钻",(long)[productModel.Diamond integerValue]];
    }
    self.lblName.text = productModel.ProductName;
    self.lblPrice.attributedText = [NSString getListPagePriceWithPrice:productModel.Price];
    NSString *goTraveNumStr=[productModel.GoTravelNum stringByReplacingOccurrencesOfString:@"已有" withString:@""];
    goTraveNumStr=[goTraveNumStr isEqualToString:@"0人出行"]?@"":goTraveNumStr;
    self.lblGoTravelNum.text=goTraveNumStr;

    if (productModel.SavePrice.length==0) {
        self.lblSavePrice.hidden=YES;
    }else
    {
        self.lblSavePrice.hidden=NO;
    }
    self.lblSavePrice.text=productModel.SavePrice;
    
    
    if (productModel.MobileCheap.length==0) {
        self.lblMobileCheap.hidden=YES;
    }else
    {
        self.lblMobileCheap.hidden=NO;
        self.lblMobileCheap.text=productModel.MobileCheap;
        [self setBlueStyleWithLabel:self.lblMobileCheap];
    }
    
    if(productModel.Tag.count>0)
    {
        if (productModel.SavePrice.length==0) {
            
            if (productModel.Tag.count>=2) {
                self.lblMobileCheap.hidden=NO;
                self.lblSavePrice.hidden=NO;
                self.lblSavePrice.text=productModel.Tag[0];
                self.lblMobileCheap.text=productModel.Tag[1];
                [self setNewStyleWithLabel:self.lblSavePrice];
                [self setNewStyleWithLabel:self.lblMobileCheap];
            }else
            {
                self.lblSavePrice.hidden=YES;
                self.lblSavePrice.text=productModel.Tag[0];
                [self setNewStyleWithLabel:self.lblSavePrice];
            }
        }else
        {
            self.lblMobileCheap.hidden=NO;
            self.lblMobileCheap.text=productModel.Tag[0];
            [self setNewStyleWithLabel:self.lblMobileCheap];
        }
    }
    
    if(self.lblSavePrice.hidden == NO)
    {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.lblSavePrice.font,NSFontAttributeName,nil];
        CGSize  actualsize =[productModel.SavePrice boundingRectWithSize:CGSizeMake(60,21) options:NSStringDrawingTruncatesLastVisibleLine  attributes:tdic context:nil].size;
        CGRect frame=self.lblSavePrice.frame;
        actualsize.height=21;
        actualsize.width+=10;
        frame.size=actualsize;
        [self.lblSavePrice sizeToFit];
        self.lblSavePrice.frame=frame;
        [self setRedStlyeWithLabel:self.lblSavePrice];
        
        CGRect frame1 = self.lblMobileCheap.frame;
        if(self.lblSavePrice.hidden == NO)
        {
            frame1.origin.x = X(self.lblSavePrice) + actualsize.width + 6;
        }else
        {
            frame1.origin.x = 120;
        }
        self.lblMobileCheap.frame = frame1;
    }
}
-(void)setRedStlyeWithLabel:(UILabel*)lbl
{
    lbl.textColor=[UIColor ColorRGBWithString:@"ff5c85"];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.layer.cornerRadius=2;
    lbl.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    lbl.layer.borderWidth=0.5f;
    lbl.layer.borderColor = lbl.textColor.CGColor;
    lbl.font = [UIFont systemFontOfSize:14];
}
-(void)setBlueStyleWithLabel:(UILabel *)lbl
{
    lbl.textColor=[UIColor ColorRGBWithString:@"#6ecdff"];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.layer.cornerRadius=2;
    lbl.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    lbl.layer.borderWidth=0.5f;
    lbl.layer.borderColor = lbl.textColor.CGColor;
    lbl.font = [UIFont systemFontOfSize:14];
}
-(void)setNewStyleWithLabel:(UILabel *)lbl
{
    lbl.textColor = [UIColor whiteColor];
    lbl.backgroundColor=[UIColor ColorRGBWithString:@"#e7016e"];
    lbl.layer.cornerRadius=2;
    lbl.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    lbl.layer.borderWidth=0.5f; 
    lbl.layer.borderColor = lbl.backgroundColor.CGColor;
    lbl.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:14];
}

@end
