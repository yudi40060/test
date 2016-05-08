//
//  UZAllDestinationVC.h
//  Uzai
//
//  Created by Uzai-macMini on 15/12/11.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZBaseVC.h"
#import "UZHomeClass.h"
@interface UZAllDestinationVC : UZBaseVC


@property (nonatomic, strong) UZHomeClass *allHomeClass;
@property (nonatomic, strong) NSString *parentName;//父级导航名称(迪拜的为中东非洲)
@property (nonatomic, strong) NSString *travelClassIDStr;//出境游还是国内游、海岛游...
-(id)initWithService:(UZHomeService *)service;
@end
