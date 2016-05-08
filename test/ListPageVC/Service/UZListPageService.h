//
//  UZListPageService.h
//  Uzai
//
//  Created by uzai on 15/12/18.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZBaseService.h"
#import "UZListPgeModel.h"

@interface UZListPageService : UZBaseService

@property (nonatomic, strong)  UZListPgeModel * listPageModel;
@property (nonatomic, strong)  NSMutableArray * listPageCityList;

//产品列表接口，5.4.3开始启用
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
                   SuccessBlock:(void(^)(NSArray *productList,NSUInteger total,NSString *travelWay))successBlock
                 withFiledBlock:(void(^)(NSString *code,NSString *msg))filedBlock;

//UserID	Int	Y	用户ID
//TravelClassID	Int	N	线路类型：0全部   1 为“出境游”，2为“国内游”，3为“周边游”，238为 “邮轮游”，9896:海岛
//
//SearchContent	String	Y	查询内容
//ProductType	Int	Y	查询类型： 1代表查跟团，2代表查自由行，0代表查全部
//
//GoDate	String	Y 	出行日期： 2017/12/01  or  2017/12/?（2017年12月的每一天）
//
//Days	String	Y	天数范围： X-X 天  最低1天  最大?（代表X天以上,如5天以上:5-?)天
//
//Price	String	 Y	价格范围： X-X 元  最低1元  最大?（代表X元以上,如3000以上:3000-?)元
//
//Diamond	Int	Y	产品钻石等级
//Keyword	String	Y	标签所含关键字
//StartIndex	Int	N	当前查询页面
//Count	Int	N	查询条数
//OrderBy	Int	Y	排序方式：排序（1推荐热门，2价格升序，3销量降序，5价格降序，


///获取产品列表  5.4.2与前版本调用该接口，5.4.3开始弃用
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
                          ReqImageSize:(NSArray *)ReqImageSize
                             StartCity:(NSString *)StartCity
                          SuccessBlock:(void(^)(NSArray *productList,NSString *travelWay))successBlock
                        withFiledBlock:(void(^)(NSString *code,NSString *msg))filedBlock;
/*
 SubjectCondition	String	Y	主题查询
 
 Count	Int	N	获取产品数量
 Keyword	String	Y	针对邮轮特殊处理或者自驾游的星级酒店，传邮轮的公司名字或者是标签名字
 
 ProductTypeCondition	String	Y	产品类型查询（根据导航类型返回的参数）
 SearchContent	String	N	查询内容
 OrderBy	Int	N	排序（1推荐热门，2价格升序，3销量降序，4推荐冷门，5价格降序，6，销售量升序,  ）
 PriceRangeID	Int	N	价格范围（11：300以下；12：300-800；13：800-2000；14：2000以上）
 
 GoDateCondition	String	Y	出行日期查询
 
 QueryType	Int	N	查询类型 =1代表查跟团，=2代表查自由行，=0代表查全部
 
 TravelClassID	Int	N	线路类型ID（1出境游；2国内游，3周边游，0全部）
 Days	Int	Y	周边游用
 
 DayRangeID	Int	Y	出行天数范围ID(1:1-3天;2:3-7天;3:7天以上)
 
 StartIndex	Int	N	分页页数
 ReqImageSize	IList<string>
 N	例子：120*160 width*height
 TravelWay-查询线路有哪些类型(1跟团游；2自由行，0全部,-1无数据)
 */

//精确查找

-(void)searchCityWithTravelClassType:(NSString *)TravelClassType
                       SearchContent:(NSString *)SearchContent
                        SuccessBlock:(void(^)(NSArray *DataList))successBlock
                      withFiledBlock:(void(^)(NSString *code,NSString *msg))filedBlock;

//获取目的地的列表
-(void)DestinationWithWidth:(NSString *)Width
                  NavLinkID:(NSString *)NavLinkID
          UzaiTravelClassID:(NSString *)UzaiTravelClassID
                    SavDate:(NSString *)SavDate
           WithSuccessBlock:(void (^)(NSArray *messageList))successBlock
            withFailedBlock:(void (^)(NSString *code, NSString *msg))FailedBlock;

//获取目的地的列表 新接口
-(void)getDestinationChannelDataWithNavLinkType:(NSInteger )navLinkType
                                  withNavLinkID:(NSInteger)navLinkId
                               withHotNavEnable:(NSInteger)hotNavEnable
                                   withSaveData:(NSString *)saveData
                               withSuccessBlock:(void (^)(NSArray *destinationList, NSString *lastTime))successBlock
                                withFailedBlock:(void (^)(NSString *code, NSString *msg))FailedBlock;
@end
