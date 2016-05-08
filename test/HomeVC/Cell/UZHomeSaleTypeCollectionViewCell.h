//
//  UZHomeSaleTypeCollectionViewCell.h
//  Uzai
//
//  Created by Uzai on 15/12/16.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZHomeSaleTypeCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) void (^selectImageIndex)(NSUInteger index);
@property (nonatomic,strong) NSArray *dataList;
-(void)dataSource:(NSArray *)dataList isEqualTotalCount:(BOOL)isEqualCount withSelectIndex:(void(^)(NSUInteger index))selectImageIndex;
@end
