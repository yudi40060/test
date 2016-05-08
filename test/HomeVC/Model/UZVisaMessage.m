//
//  UZVisaMessage.m
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZVisaMessage.h"

@implementation UZVisaMessage

+(UZVisaMessage *)visMessageWithDict:(NSDictionary *)dict
{
    UZVisaMessage *visaModel=[[UZVisaMessage alloc]init];
    visaModel.Type=[dict[@"Type"] toString];
    visaModel.Url=[dict[@"Url"] toString];
    visaModel.Name=[dict[@"Name"] toString];
    visaModel.WorkTime=[dict[@"WorkTime"] toString];
    visaModel.VisaPrice=[dict[@"VisaPrice"] toString];
    visaModel.VisaArea=[dict[@"VisaArea"] toString];
    visaModel.IsContainVisa=[dict[@"IsContainVisa"] toString];
    visaModel.IsContainVisa=[dict[@"IsContainVisa"] toString];
    return visaModel;
}

@end
