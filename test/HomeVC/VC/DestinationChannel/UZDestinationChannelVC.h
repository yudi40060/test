//
//  UZDestinationChannelVC.h
//  Uzai
//
//  Created by Uzai-macMini on 15/12/11.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZBaseVC.h"
#import "UZHomeClass.h"
@interface UZDestinationChannelVC : UZBaseVC

@property (nonatomic, strong) UZHomeClass *homeClass;
@property (nonatomic, strong) NSString *travelTypeStr;//国内、境外、当季去哪儿
@property (nonatomic, strong) NSString *field2Str;
@property (nonatomic, assign) NSInteger rowCount;//如果是国内则为3,其余都是2
@property (nonatomic, strong) NSString *travelClassIDStr;//出境游1、国内游2...
-(id)initWithService:(UZHomeService *)service;
@end
