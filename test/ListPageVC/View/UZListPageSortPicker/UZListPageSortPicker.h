//
//  UZListPageSortPicker.h
//  UZai5.2
//
//  Created by uzai on 14-9-11.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZListPageService.h"

@interface UZListPageSortPicker : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIView *subView;
    NSArray *arrWithData;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)  UZListPageService * service;
@property (nonatomic,copy) void (^onclik)(id data);
@property (nonatomic, assign)  BOOL  showState;
-(id)initWithService:(UZListPageService *)service;
-(void)showWithOnClick:(void(^)(id data))onclickBlock;
-(void)hideWithMessage:(id)data;
@end
