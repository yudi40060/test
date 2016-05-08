//
//  UZHomeCategoryCollectionViewCell.h
//  Uzai
//
//  Created by Uzai on 16/1/20.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZHomeCategoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UZBaseImageView *imgView;
@property (nonatomic,assign) BOOL isLastCell;
@end
