//
//  UZVisaVC.h
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZBaseVC.h"
#import "UZProductService.h"

@interface UZVisaVC : UZBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIImageView *imageSearch;
@property (nonatomic, strong)  UZProductService * service;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
-(id)initWithService:(UZProductService *)service;
@end
