//
//  UZHomeClassCollectionViewCell.h
//  Uzai
//
//  Created by Uzai on 15/12/2.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZHomeClassCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstaints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstaints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstaints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstaints;
@property (weak, nonatomic) IBOutlet UZBaseImageView *classImgView;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
-(void)datasource:(NSString *)classNameLabel
           imgUrl:(NSString *)imgUrl;
@end
