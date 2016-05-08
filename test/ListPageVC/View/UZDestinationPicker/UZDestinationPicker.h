//
//  UZDestinationPicker.h
//  UZai5.2
//
//  Created by uzai on 14-9-12.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZListPageService.h"
#import "IZValueSelectorView.h"
@interface UZDestinationPicker : UIView<IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>

@property (weak, nonatomic) IBOutlet IZValueSelectorView *tableViewLeft;
@property (weak, nonatomic) IBOutlet IZValueSelectorView *tableViewRight;
@property (nonatomic,copy) void (^onclik)(id data);
@property (nonatomic, strong)  UZListPageService * service;
@property (nonatomic, assign)  BOOL  showState;

-(id)initWithService:(UZListPageService *)service;

-(void)showWithOnClick:(void(^)(id data))onclickBlock;
-(void)hideWithStr:(NSString *)str;
@end
