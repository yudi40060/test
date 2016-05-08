//
//  DiamondLevelView.h
//  Uzai
//
//  Created by uzai on 15/12/28.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiamondLevelView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,copy) void (^onclik)(NSUInteger selectIndex);
-(void)selectIndex:(void(^)(NSUInteger selectIndex))onclickBlock;
-(void)setSelectIndex:(NSUInteger)index;
@end
