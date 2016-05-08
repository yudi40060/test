//
//  UZHomeHeadView.m
//  UZai5.2
//
//  Created by uzai on 15/6/3.
//  Copyright (c) 2015年 xiaowen. All rights reserved.
//

#import "UZHomeHeadView.h"

@implementation UZHomeHeadView
{
    CAGradientLayer *shaowLayer;
    BOOL isAdd;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    if (Main_Screen_Width<375) {
         self.promptTextLabel.font=[UIFont systemFontOfSize:12.0];
    }
   
    if (!isAdd) {
        self.searchView.layer.cornerRadius  = HEIGHT(self.searchView)/2;
        self.searchView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self.searchView addGestureRecognizer:tap];
        shaowLayer = [self shadowAsInverse];
        [self.layer insertSublayer:shaowLayer atIndex:0];
        isAdd = YES;
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
}
-(void)tapScanning
{
    self.SelectIndexBlock(105);
}
-(void)tap:(id)sender
{
    self.SelectIndexBlock(101);
}

- (IBAction)clickScaningBtn:(id)sender {
    [self tapScanning];//二维码扫描
}

- (IBAction)onclick:(id)sender {
    UIButton *btn = sender;
    self.SelectIndexBlock(btn.tag);
}
-(void)setCityNameWithStr:(NSString *)city
{
    self.lblCity.text = city;
}
-(void)setNormalState
{
//    self.lblCity.textColor = [UIColor whiteColor];
//    [self.btnPhone setImage:[UIImage imageNamed:@"icon_home_phone"] forState:UIControlStateNormal];
//    self.imageLocation.image=[UIImage imageNamed:@"location_white"];
    if ([shaowLayer superlayer] == nil) {
        [self.layer insertSublayer:shaowLayer atIndex:0];
    }
}
-(void)setOffsetState
{
//    self.lblCity.textColor = [UIColor ColorRGBWithString:RGBStringColor];
//     [self.btnPhone setImage:[UIImage imageNamed:@"icon_home_phone2"] forState:UIControlStateNormal];
//    self.imageLocation.image=[UIImage imageNamed:@"location"];
    [shaowLayer removeFromSuperlayer];
}

-(CAGradientLayer *)shadowAsInverse
{
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.frame = self.bounds;
    layer.colors = [NSArray arrayWithObjects:(id)[[UIColor alloc]initWithWhite:1 alpha:0.5].CGColor,(id)[[UIColor alloc]initWithWhite:1 alpha:0.1].CGColor,(id)[UIColor clearColor].CGColor, nil];
    
    return layer;
}
@end
