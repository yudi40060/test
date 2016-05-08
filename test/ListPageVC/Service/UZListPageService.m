//
//  UZListPageService.m
//  Uzai
//
//  Created by uzai on 15/12/18.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZListPageService.h"
#import "UZBusinessNetwork+UZListPage.h"
#import "UZBusinessNetwork+UZHome.h"

@implementation UZListPageService
-(id)init
{
    self=[super init];
    if (self) {
        self.listPageModel=[[UZListPgeModel alloc]init];
    }
    return self;
    
}

-(void)getProductListWithUserID:(NSString *)userID
               andTravelClassID:(NSUInteger)travelClassID
               andSearchContent:(NSString *)searchContent
                 andProductType:(NSUInteger)productType
                      andGoDate:(NSString *)goDate
                        andDays:(NSString *)days
                       andPrice:(NSString *)price
                     andDiamond:(NSUInteger)diamond
                     andKeyword:(NSString *)keyword
                  andStartIndex:(NSUInteger)startIndex
                       andCount:(NSUInteger)count
                     andOrderBy:(NSUInteger)orderBy
                   SuccessBlock:(void (^)(NSArray *, NSUInteger,NSString *))successBlock withFiledBlock:(void (^)(NSString *, NSString *))filedBlock
{
    [self.network getProductListWithUserID:userID andTravelClassID:travelClassID andSearchContent:searchContent andProductType:productType andGoDate:goDate andDays:days andPrice:price andDiamond:diamond andKeyword:keyword andStartIndex:startIndex andCount:count andOrderBy:orderBy SuccessBlock:^(NSArray *productList, NSUInteger total,NSString *travelWay) {
        BLOCK_SAFE(successBlock)(productList,total,travelWay);
    } withFiledBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(filedBlock)(code,msg);
    }];
}
-(void)productListWithSubjectCondition:(NSString *)SubjectCondition
                                 Count:(NSUInteger)Count
                               Keyword:(NSString *)Keyword
                  ProductTypeCondition:(NSString *)ProductTypeCondition
                         SearchContent:(NSString *)SearchContent
                               OrderBy:(NSUInteger)OrderBy
                          PriceRangeID:(NSUInteger)PriceRangeID
                       GoDateCondition:(NSString *)GoDateCondition
                             QueryType:(NSUInteger) QueryType
                         TravelClassID:(NSUInteger) TravelClassID
                                  Days:(NSUInteger)Days
                            DayRangeID:(NSUInteger)DayRangeID
                            StartIndex:(NSUInteger)StartIndex
                               Diamond:(NSUInteger)Diamond
                          ReqImageSize:(NSArray *)ReqImageSize StartCity:(NSString *)StartCity SuccessBlock:(void (^)(NSArray *,NSString*))successBlock withFiledBlock:(void (^)(NSString *, NSString *))filedBlock
{
    [self.network getproductListWithSubjectCondition:SubjectCondition Count:Count Keyword:Keyword ProductTypeCondition:ProductTypeCondition SearchContent:SearchContent OrderBy:OrderBy PriceRangeID:PriceRangeID GoDateCondition:GoDateCondition QueryType:QueryType TravelClassID:TravelClassID Days:Days DayRangeID:DayRangeID StartIndex:StartIndex Diamond:Diamond ReqImageSize:ReqImageSize StartCity:StartCity SuccessBlock:^(NSArray *productList,NSString *travelWay) {
        BLOCK_SAFE(successBlock)(productList,travelWay);
        
    } withFiledBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(filedBlock)(code,msg);
    }];
}
// 精确查找
-(void)searchCityWithTravelClassType:(NSString *)TravelClassType
                       SearchContent:(NSString *)SearchContent
                        SuccessBlock:(void(^)(NSArray *DataList))successBlock
                      withFiledBlock:(void(^)(NSString *code,NSString *msg))filedBlock;
{
    [self.network getSearchCityWithTravelClassType:TravelClassType SearchContent:SearchContent SuccessBlock:^(NSArray *DataList) {
        BLOCK_SAFE(successBlock)(DataList);
    } withFiledBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(filedBlock)(code,msg);
    }];
}
//获取目的地的列表
-(void)DestinationWithWidth:(NSString *)Width
                  NavLinkID:(NSString *)NavLinkID
          UzaiTravelClassID:(NSString *)UzaiTravelClassID
                    SavDate:(NSString *)SavDate
           WithSuccessBlock:(void (^)(NSArray *messageList))successBlock
            withFailedBlock:(void (^)(NSString *code, NSString *msg))FailedBlock;
{
    [self.network getDestinationWithWidth:Width NavLinkID:NavLinkID UzaiTravelClassID:UzaiTravelClassID SavDate:SavDate WithSuccessBlock:^(NSArray *messageList) {
        BLOCK_SAFE(successBlock)(messageList);
    } withFailedBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(FailedBlock)(code,msg);
    }];
}
-(void)getDestinationChannelDataWithNavLinkType:(NSInteger )navLinkType
                                  withNavLinkID:(NSInteger)navLinkId
                               withHotNavEnable:(NSInteger)hotNavEnable
                                   withSaveData:(NSString *)saveData
                               withSuccessBlock:(void (^)(NSArray *destinationList, NSString *lastTime))successBlock
                                withFailedBlock:(void (^)(NSString *code, NSString *msg))FailedBlock
{
    [self.network getDestinationChannelDataWithNavLinkType:navLinkType withNavLinkID:navLinkId withHotNavEnable:hotNavEnable withSaveData:saveData withSuccessBlock:^(NSArray *destinationList, NSString *lastTime) {
        BLOCK_SAFE(successBlock)(destinationList,lastTime);
    } withFailedBlock:^(NSString *code, NSString *msg) {
        BLOCK_SAFE(FailedBlock)(code,msg);
    }];
}
@end
