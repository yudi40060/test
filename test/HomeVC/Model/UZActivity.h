//
//  UZActivity.h
//  UZai5.2
//
//  Created by UZAI on 14-9-4.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

//首页的活动
@interface UZActivity : NSObject
@property (nonatomic,retain) NSString *activityUrl;
@property (nonatomic,retain) NSString *hotTree;
@property (nonatomic,retain) NSString *iD;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *productID;
@property (nonatomic,retain) NSString *topicsID;
@property (nonatomic,retain) NSString *topicsImgUrl;
@property (nonatomic,retain) NSString *topicsImgUrlHorizontal;
@property (nonatomic,retain) NSString *topicsName;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *userAlreadyShare;
@property (nonatomic,retain) NSString *uzaiTravelClassID;
@property (nonatomic,retain) NSString *tagIndex;
@property (nonatomic,retain) NSString *isShare;
@property (nonatomic,retain) NSString * shareContent;
@property (nonatomic,retain) NSString *imgUrl;
@property (nonatomic,retain) NSString *keyword;
@property (nonatomic,retain) NSString *sort;
@property (nonatomic,retain) NSString *homeTagIndex;
+(UZActivity *)activityWithDict:(NSDictionary *)dict;
+(NSMutableArray *)arrayListWithKeyList:(NSArray *)keyDataList;
@end
