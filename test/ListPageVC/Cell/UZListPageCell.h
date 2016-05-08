//
//  UZListPageCell.h
//  UZai5.2
//
//  Created by uzai on 14-9-10.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZProductDetailList.h"
#import "UZListPageProductModel.h"

@interface UZListPageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UZBaseImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblGoDate;
@property (weak, nonatomic) IBOutlet UILabel *lblGoTravelNum;
@property (weak, nonatomic) IBOutlet UILabel *lblSavePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblStartCity;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileCheap;
@property (weak, nonatomic) IBOutlet UILabel *lblTenYear;
@property (weak, nonatomic) IBOutlet UILabel *lblDiamond;
@property (weak, nonatomic) IBOutlet UIImageView *imageDiamondBg;

-(void)setRedStlyeWithLabel:(UILabel*)lbl;
-(void)setBlueStyleWithLabel:(UILabel *)lbl;
-(void)setNewStyleWithLabel:(UILabel *)lbl;

-(void)setData:(UZProductDetailList *)productModel;
-(void)setData1:(UZListPageProductModel *)productModel;
@end
