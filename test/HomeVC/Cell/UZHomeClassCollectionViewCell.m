//
//  UZHomeClassCollectionViewCell.m
//  Uzai
//
//  Created by Uzai on 15/12/2.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeClassCollectionViewCell.h"

@implementation UZHomeClassCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)dealloc
{
    self.classImgView=nil;
    self.classLabel=nil;
}

-(void)datasource:(NSString *)classNameLabel
           imgUrl:(NSString *)imgUrl;
{
    self.classLabel.text=classNameLabel;
    [self.classImgView setImageWithUrlStr:imgUrl placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
    __weak UZHomeClassCollectionViewCell *weakSelf=self;
    [UZTheadCommon enqueueMainThreadPool:^{
        weakSelf.leftConstaints.constant=13*Main_Screen_Width/375;
        weakSelf.rightConstaints.constant=13*Main_Screen_Width/375;
        weakSelf.topConstaints.constant=12*Main_Screen_Width/375;
        weakSelf.bottomConstaints.constant=11*Main_Screen_Width/375;
        [weakSelf updateConstraints];//更新布局
    }];
}

@end
