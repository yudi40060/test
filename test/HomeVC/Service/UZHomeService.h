//
//  UZHomeService.h
//  Uzai
//
//  Created by Uzai on 15/12/1.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UZBaseService.h"
#import "UZCity.h"
#import "UZRushBuyInfo.h"
#import "UZQRModel.h"
#import "UZKeSongFangConfigModel.h"
@interface UZHomeService : UZBaseService

@property (nonatomic,strong) NSMutableArray *cityDataList;
@property (nonatomic,strong) NSMutableArray *hotCityDataList;

//查询出发的城市
-(UZCity *)QueryStartCity;
//删除表格
-(void)deleteStartCity;
//插入数据
-(void)insertStartCity:(UZCity *)City;
/**
 *params startId
 *根据城市的ID，获取城市的列表
 */
-(void)cityListWithSuccessBlock:(void(^)(NSArray *DataList,NSArray *hotCityList))successBlock
                 withFiledBlock:(void(^)(NSString *code,NSString *msg))filedBlock;


/**
 *  定制游的添加
 *
 *  @param userId       用户ID
 *  @param UserNeeds    用户信息
 *  @param successBlock 成功
 *  @param filedBlock   失败
 */
-(void)DingzhiyouWithUserID:(NSString *)userId
                  UserNeeds:(NSString *)UserNeeds
               SuccessBlock:(void (^)(void))successBlock
             withFiledBlock:(void (^)(NSString *code, NSString *msg))filedBlock;

///--5.4搜索
-(void)searchHotWordsWithUserID:(NSString *)userId
               withSuccessBlock:(void (^)(NSArray *userSearchList, NSArray *hotWordsList))successBlock
                withFailedBlock:(void (^)(NSString *code, NSString *msg))FailedBlock;

/**
 *  获取首页
 *
 *  @param successBlock 成功
 *  @param filedBlock   失败

 */
-(void)IndexWithSuccesBlock:(void (^)(void))successBlock
             withFiledBlock:(void (^)(NSString *code, NSString *msg))filedBlock;

/**
 *  获取服务器时间
 *
 *  @param successBlock 成功
 *  @param filedBlock   失败
 */
-(void)getServiceTime:(void (^)(void))successBlock
       withFiledBlock:(void (^)(NSString *code, NSString *msg))filedBlock;

//猜你喜欢
-(void)indexProductWithUserId:(NSString *)userId
                 SuccessBlock:(void (^)( NSArray *productList))successBlock
               withFiledBlock:(void (^)(NSString *code, NSString *msg))filedBlock;
/**
 *  获取目的地频道页数据
 *
 *  @param navLinkType  导航大分类
 *  @param nsvLinkId    导航父id
 *  @param hotNavEnable 热门还是全部(热门传1，全部传0)
 *  @param successBlock 成功
 *  @param filedBlock   失败
 */
-(void)destinationChannelDataWithNavLinkType:(NSInteger )navLinkType
                                  withNavLinkID:(NSInteger)navLinkId
                            withHotNavEnable:(NSInteger)hotNavEnable withSaveData:(NSString *)saveData
                               withSuccessBlock:(void (^)(NSArray *destinationList, NSString *lastTime))successBlock
                                withFailedBlock:(void (^)(NSString *code, NSString *msg))FailedBlock;

/**
 *  可颂坊
 *
 *  @param successBlock 成功
 *  @param filedBlock
 */
-(void)getQRCode:(void (^)(UZQRModel *))successBlock filedBlock:(void (^)(NSString *, NSString *))filedBlock;

/**
 *  获取可颂坊消息
 *
 *  @param successBlock
 *  @param filedBlock   
 */
-(void)getKeSongFangConfig:(void (^)(UZKeSongFangConfigModel *model))successBlock filedBlock:(void (^)(NSString *, NSString *))filedBlock;
@end
