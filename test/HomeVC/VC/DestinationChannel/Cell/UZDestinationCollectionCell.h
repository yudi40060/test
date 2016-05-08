//
//  UZDestinationCollectionCell.h
//  WPUzaiDemo
//
//  Created by Uzai-macMini on 15/12/2.
//  Copyright © 2015年 Uzai-macMini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZHomeClass.h"
@interface UZDestinationCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UZBaseImageView *destinationImg;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *destinationImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *destinationImgHeight;

-(void)setDataSource:(UZHomeSubClass *)homeSubClass withImgUrl:(NSString *)imageUrl;

@end
