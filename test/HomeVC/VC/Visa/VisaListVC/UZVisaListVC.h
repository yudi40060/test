//
//  UZVisaListVC.h
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZBaseVC.h"
#import "UZProductService.h"
#import "UZVisCountry.h"

@interface UZVisaListVC : UZBaseVC
{
    
}
@property (nonatomic, strong)  UZVisCountry *visaCountryModel;
@property (nonatomic, strong)  UZProductService * service;
@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
-(id)initWithService:(UZProductService *)service andVisaCountry:(UZVisCountry *)visaCountryModel;
@end
