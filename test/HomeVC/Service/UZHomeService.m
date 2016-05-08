//
//  UZHomeService.m
//  Uzai
//
//  Created by Uzai on 15/12/1.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeService.h"
#import "UZBusinessNetwork+UZHome.h"
#import "UZSqliteCache.h"
#import "UZRushBuyInfo.h"
#import "UZQRModel.h"
@implementation UZHomeService

//查询出发的城市
-(UZCity *)QueryStartCity
{
    UZ_CLIENT.city=[UZSqliteCache QueryStartCityList];
    UZ_CLIENT.cityName=UZ_CLIENT.city.CityName;
    return UZ_CLIENT.city;
}
//删除表格
-(void)deleteStartCity
{
    [UZSqliteCache deleteStartCity];
}
//插入数据
-(void)insertStartCity:(UZCity *)City
{
    [UZSqliteCache insertStartCity:City];
}
/**
 *params startId
 *根据城市的ID，获取城市的列表
 */
-(void)cityListWithSuccessBlock:(void(^)(NSArray *DataList,NSArray *hotCityList))successBlock
                 withFiledBlock:(void(^)(NSString *code,NSString *msg))filedBlock
{
    [self.network getCityListSuccessBlock:^(NSArray *cityList, NSArray *hotCityList) {
        BLOCK_SAFE(successBlock)(cityList,hotCityList);
    } withFiledBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(filedBlock)(code,msg);
    }];
}
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
{
    [self.network postDingzhiyouWithUserID:userId UserNeeds:UserNeeds SuccessBlock:^{
        BLOCK_SAFE(successBlock)();
    } withFiledBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(filedBlock)(code,msg);
    }];
}

////5.4搜索热词新接口wp
-(void)searchHotWordsWithUserID:(NSString *)userId withSuccessBlock:(void (^)(NSArray *, NSArray *))successBlock withFailedBlock:(void (^)(NSString *, NSString *))FailedBlock
{
    [self.network getSearchHotWordWithUserID:userId withSuccessBlock:^(NSArray *userSearchList, NSArray *hotWordsList) {
        BLOCK_SAFE(successBlock)(userSearchList,hotWordsList);
    } withFailedBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(FailedBlock)(code,msg);
    }];
}
/**
 *  获取首页
 *
 *  @param successBlock 成功
 *  @param filedBlock   失败
 */
-(void)IndexWithSuccesBlock:(void (^)(void))successBlock
             withFiledBlock:(void (^)(NSString *code, NSString *msg))filedBlock;
{
   
    [self.network getIndexWithSuccessBlock:^ {
        BLOCK_SAFE(successBlock)();
    } withFiledBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(filedBlock)(code,msg);
    }];
}
-(void)getServiceTime:(void (^)(void))successBlock
       withFiledBlock:(void (^)(NSString *code, NSString *msg))filedBlock
{
    [self.network getServiceTime:^{
        BLOCK_SAFE(successBlock)();
    } withFiledBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(filedBlock)(code,msg);
    }];
}

//猜你喜欢
-(void)indexProductWithUserId:(NSString *)userId
                 SuccessBlock:(void (^)( NSArray *productList))successBlock
               withFiledBlock:(void (^)(NSString *code, NSString *msg))filedBlock;
{
    [self.network getIndexProductWithUserId:UZ_CLIENT.UserID SuccessBlock:^(NSArray *productList) {
        BLOCK_SAFE(successBlock)(productList);
    } withFiledBlock:^(NSString *code, NSString *msg) {
         BLOCK_SAFE(filedBlock)(code,msg);
    }];
}
/**
 *  获取目的地频道页数据
 *
 *  @param navLinkType  导航大分类
 *  @param nsvLinkId    导航父id
 *  @param hotNavEnable 热门还是全部(热门传1，全部传0)
 *  @param successBlock 成功
 *  @param filedBlock   失败
 */
-(void)destinationChannelDataWithNavLinkType:(NSInteger)navLinkType withNavLinkID:(NSInteger)navLinkId withHotNavEnable:(NSInteger)hotNavEnable withSaveData:(NSString *)saveData withSuccessBlock:(void (^)(NSArray *, NSString *))successBlock withFailedBlock:(void (^)(NSString *, NSString *))FailedBlock
{
    [self.network getDestinationChannelDataWithNavLinkType:navLinkType withNavLinkID:navLinkId withHotNavEnable:hotNavEnable withSaveData:saveData withSuccessBlock:^(NSArray *destinationList, NSString *lastTime) {
        BLOCK_SAFE(successBlock)(destinationList,lastTime);
    } withFailedBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(FailedBlock)(code,msg);
    }];
}

-(void)getQRCode:(void (^)(UZQRModel *))successBlock filedBlock:(void (^)(NSString *, NSString *))filedBlock
{
    [self.network getQRCode:^(UZQRModel *model) {
        BLOCK_SAFE(successBlock)(model);
    } filedBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(filedBlock)(code,msg);
    }];
}

-(void)getKeSongFangConfig:(void (^)(UZKeSongFangConfigModel *model))successBlock filedBlock:(void (^)(NSString *, NSString *))filedBlock
{
    [self.network getKeSongFangConfig:^(UZKeSongFangConfigModel *model) {
        BLOCK_SAFE(successBlock)(model);
    } filedBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(filedBlock)(code,msg);
    }];
}


@end
