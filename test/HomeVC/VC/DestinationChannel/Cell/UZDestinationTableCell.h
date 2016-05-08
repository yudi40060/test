//
//  UZDestinationTableCell.h
//  Uzai
//
//  Created by Uzai-macMini on 16/1/5.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickHotDestinationIndex)(NSUInteger);
@interface UZDestinationTableCell : UITableViewCell

@property (nonatomic,strong) clickHotDestinationIndex destinationIndexBlock;
@property (nonatomic, strong) UILabel *titleLabel;//标题label
@property (nonatomic, strong) UIButton *moreButn;//更多按钮
@property (nonatomic, assign) BOOL hideMoreButn;//当季推荐频道页和周边游隐藏更多按钮
@property (nonatomic, strong) UICollectionView *hotDestinationCollection;
-(void)setDataSourceWithArray:(NSArray *)dataArr
           withclassBlock:(clickHotDestinationIndex)destinationBlock;
-(void)reload;
@end
