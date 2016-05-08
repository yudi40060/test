//
//  UZListPageFooterView.h
//  Uzai
//
//  Created by uzai on 15/12/23.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZListPageService.h"
@interface UZListPageFooterView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@property (nonatomic, strong)  UZListPageService * service;
@property (nonatomic, assign)  BOOL isShowDesination;
@property (nonatomic,copy) void (^onclik)(NSInteger selectIndex);

-(void)selectIndex:(void(^)(NSInteger selectIndex))onclickBlock;
-(void)setShowDesination:(BOOL)isShowDesination;
-(void)reset;
-(void)reload;
@end
