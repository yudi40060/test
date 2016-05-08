//
//  UZHomeVC.h
//  Uzai
//
//  Created by Uzai on 15/12/1.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZHomeHeadView.h"
@interface UZHomeVC : UIViewController
-(void)loadData:(BOOL)isdragRefresh;
@property (nonatomic,strong) UZHomeHeadView *headerView;
-(void)goSearchVC;
//扫描
-(void)goScaningVC;
+(void)pushActiveVC:(UZActivity *)activity withEventName:(NSString *)pageEventName andCurrentVC:(UIViewController *)currentVC;
@end
