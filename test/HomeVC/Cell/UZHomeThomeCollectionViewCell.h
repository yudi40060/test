//
//  UZHomeThomeCollectionViewCell.h
//  Uzai
//
//  Created by Uzai on 15/12/3.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZHomeThomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstaints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraints;
@property (weak, nonatomic) IBOutlet UZBaseImageView *imgV;
-(void)dataSourceWithIndexPath:(NSIndexPath *)indexPath withImgUrl:(NSString *)imgUrl;
@end
