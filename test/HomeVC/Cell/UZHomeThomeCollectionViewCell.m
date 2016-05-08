//
//  UZHomeThomeCollectionViewCell.m
//  Uzai
//
//  Created by Uzai on 15/12/3.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeThomeCollectionViewCell.h"

@implementation UZHomeThomeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)dataSourceWithIndexPath:(NSIndexPath *)indexPath withImgUrl:(NSString *)imgUrl;{
    if ((indexPath.row+1)%2==0) {
        self.leftConstaints.constant=3;
        self.rightConstraints.constant=5;
    }else
    {
        self.leftConstaints.constant=5;
        self.rightConstraints.constant=2;
    }
    [self updateConstraints];
    self.backgroundColor=[UIColor whiteColor];
    [self.imgV setImageWithUrlStr:[imgUrl getZoomImageURLWithWidth:Main_Screen_Width/2] placeholderImage:[[UIColor whiteColor] colorTransformToImage] withContentMode:UIViewContentModeScaleAspectFill];
}

-(void)dealloc
{
    self.imgV=nil;
}
@end
