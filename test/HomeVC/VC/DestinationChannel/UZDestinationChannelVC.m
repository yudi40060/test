//
//  UZDestinationChannelVC.m
//  Uzai
//
//  Created by Uzai-macMini on 15/12/11.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZDestinationChannelVC.h"
#import "HMSegmentedControl.h"
#import "UZAllDestinationVC.h"
#import "UZListPageCell.h"
#import "UZProductDetailList.h"
#import "UZDestinationTableCell.h"
#import "UZCurrentSeasonCell.h"
#import "UZListPageProductModel.h"
@interface UZDestinationChannelVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentTable;
    UILabel *noMessageLabel;//无产品数据时的提示label
}
@property (nonatomic, strong) UZHomeService *service;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSMutableArray *destinationArray;//存储目的地数组
@property (nonatomic, strong) NSMutableArray *zhoubianyouArray;//周边游目的地数组
@property (nonatomic, strong) NSMutableArray *currentSeasonProductArray;//当季推荐产品数组
@property (nonatomic, strong) NSArray *titleArray;//存储切换卡标题数组
@property (nonatomic, strong) NSArray *keyWordArray;//关键字数组

@property (nonatomic, strong) UITableView *destinationTableView;
@end

@implementation UZDestinationChannelVC
//
-(id)initWithService:(UZHomeService *)service
{
    self=[super init];
    if (self) {
        _service=service;
        _destinationArray = [NSMutableArray array];
        _zhoubianyouArray = [NSMutableArray array];
        _currentSeasonProductArray = [NSMutableArray array];
        _titleArray = [NSArray array];
        _keyWordArray = [NSArray array];
        currentTable=0;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initUI];
    [self getNetworkDataWithShowLoading:YES];
    [self sendViewNameWithName:self.GAStr];
}



#pragma mark - 获取网络数据
-(void)getNetworkDataWithShowLoading:(BOOL)showLoading
{
    //获取上方热门目的地数据
    __weak UZDestinationChannelVC *weakSelf = self;
    //本地判断，邮轮NavLinkType为5，频道页国内为3，周边游为4，当季推荐为6,其余为1
    NSInteger navLinkType;
    if ([_homeClass.subClass.Fields3 isEqualToString:@"238"]) {
        //邮轮设为5
        navLinkType = 5;
    }else if ([_homeClass.subClass.Fields3 isEqualToString:@"2"])
    {
        //国内并且在频道页设为3
        navLinkType = 3;
    }else
    {
        //其余为1
        navLinkType = 1;
    }
    
    if ([self.travelTypeStr isEqualToString:@"当季去哪儿"]) {
        navLinkType = 6;
    }
    
    
    if (_destinationArray.count == 0) {
        [self showLoadingWithMessage:nil];
    }
    
    //获取热门目的地时，HotNavEnable传值为1
    [weakSelf.service destinationChannelDataWithNavLinkType:navLinkType withNavLinkID:[_homeClass.subClass.ID integerValue] withHotNavEnable:1 withSaveData:@"" withSuccessBlock:^(NSArray *destinationList, NSString *lastTime) {
        weakSelf.destinationArray = [weakSelf networkDataToNeedDataArray:destinationList];
        NSLog(@"热门目的地个数:%lu",(unsigned long)weakSelf.destinationArray.count);
        [weakSelf.destinationTableView reloadData];
    } withFailedBlock:^(NSString *code, NSString *msg) {
        NSLog(@"热门目的地错误提示:%@",msg);
    }];
    
    if ([weakSelf.travelTypeStr isEqualToString:@"国内游"]) {
        //如果为国内游，则多了一个周边游的热门目的地请求
        [weakSelf.service destinationChannelDataWithNavLinkType:4 withNavLinkID:[_homeClass.subClass.ID integerValue] withHotNavEnable:1 withSaveData:@"" withSuccessBlock:^(NSArray *destinationList, NSString *lastTime) {
            weakSelf.zhoubianyouArray = [weakSelf networkDataToNeedDataArray:destinationList];
            [weakSelf.destinationTableView reloadData];
            
            
        } withFailedBlock:^(NSString *code, NSString *msg) {
        }];
    }
    
    
    //获取下方当季推荐产品列表，调用搜索按钮
    //首先得到三个显示title以及关键字
    NSMutableArray *titleArrayTemp = [NSMutableArray array];
    NSMutableArray *keyWordArrayTemp = [NSMutableArray array];
    NSString *keyWordStr = _field2Str;
    
    if (![keyWordStr isEqualToString:@""]) {
        NSArray *tempArr = [keyWordStr componentsSeparatedByString:@","];
        for (NSString *str in tempArr) {
            
            NSArray *ttArr = [str componentsSeparatedByString:@"/"];
            [titleArrayTemp addObject:ttArr[0]];
            [keyWordArrayTemp addObject:ttArr[1]];
        }
        //获取到title以及关键字数组
        _titleArray = [NSArray arrayWithArray:titleArrayTemp];
        _keyWordArray = [NSArray arrayWithArray:keyWordArrayTemp];
        
        //调用搜索产品接口
        [self getCurrentSeasonProductDataWith:_keyWordArray[currentTable] withShowLoaing:showLoading];
    }
    
    
}
//筛选热门目的地
-(NSMutableArray *)networkDataToNeedDataArray:(NSArray *)arr
{
    NSMutableArray *needArray = [NSMutableArray array];
    
    for (UZHomeClass *tempHomeClass in arr) {
        //判断是否为热门
        if ([tempHomeClass.subClass.Fields1 isEqualToString:@"1"]) {
            //父导航为热门目的地
            [needArray addObject:tempHomeClass.subClass];
        }
        //遍历子导航
        for (UZHomeSubClass *tempSubClass in tempHomeClass.navLink) {
            [needArray addObject:tempSubClass];
        }
    }
    
    return needArray;
}
/**
 *  获取目的地频道页下方的当季推荐产品数据
 *
 *  @param keyWord  关键字字符串，用于搜索
 */
-(void)getCurrentSeasonProductDataWith:(NSString *)keyWord withShowLoaing:(BOOL)showLoading
{
    
    __weak UZDestinationChannelVC *weakSelf = self;
    
    if (showLoading) {
        //只有初次进入频道页时显示页面中央的加载
        [weakSelf showLoadingWithMessage:nil];
    }
    UZListPageService *listPageService = [[UZListPageService alloc]init];
    //下拉刷新
    [listPageService getProductListWithUserID:UZ_CLIENT.UserID andTravelClassID:[_travelClassIDStr integerValue] andSearchContent:keyWord andProductType:0 andGoDate:nil andDays:nil andPrice:nil andDiamond:0 andKeyword:nil andStartIndex:1 andCount:10 andOrderBy:listPageService.listPageModel.orderBy SuccessBlock:^(NSArray *productList, NSUInteger total, NSString *travelWay) {
        weakSelf.currentSeasonProductArray = [NSMutableArray array];
        weakSelf.currentSeasonProductArray = [NSMutableArray arrayWithArray:productList];
        //当产品数据为空时，提示为空
        if (weakSelf.currentSeasonProductArray.count == 0) {
            [weakSelf showNoMessageLabel];
        }else
        {
            [weakSelf hideNoMessageLabel];
        }
        
        [weakSelf.destinationTableView reloadData];
        [weakSelf endRefresh];
        [weakSelf hideLoading];
    } withFiledBlock:^(NSString *code, NSString *msg) {
        [weakSelf.currentSeasonProductArray removeAllObjects];
        [weakSelf showNoMessageLabel];
        [weakSelf.destinationTableView reloadData];
        [weakSelf endRefresh];
        [weakSelf hideLoading];
    }];
}
-(void)initUI
{
    _cache = [[NSCache alloc]init];
    
    _destinationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(isIOS7Above?64:44)) style:UITableViewStylePlain];
    _destinationTableView.delegate = self;
    _destinationTableView.dataSource = self;
    _destinationTableView.scrollsToTop = NO;
    _destinationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _destinationTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_destinationTableView];
    
    //    [self addFooter:_destinationTableView];
    [self addHeader:_destinationTableView];
    
}
//事件统计转换
-(void)EventCountWithNavLinkName:(NSString *)navLineName withAction:(NSString *)action
{
    NSString *categoryStr;
    
    if ([navLineName isEqualToString:@"欧洲"]) {
        categoryStr = @"c-europe";
    }else if ([navLineName isEqualToString:@"日韩"]){
        categoryStr = @"c-rihan";
    }else if ([navLineName isEqualToString:@"东·南亚"]){
        categoryStr = @"c-dongnanya";
    }else if ([navLineName isEqualToString:@"美洲"]){
        categoryStr = @"c-america";
    }else if ([navLineName isEqualToString:@"澳洲"]){
        categoryStr = @"c-australia";
    }else if ([navLineName isEqualToString:@"中东非洲"]){
        categoryStr = @"c-zhongdongfei";
    }else if ([navLineName isEqualToString:@"魅力海岛"]){
        categoryStr = @"c-island";
    }else if ([navLineName isEqualToString:@"港澳台"]){
        categoryStr = @"c-gangaotai";
    }else if ([navLineName isEqualToString:@"国内"]){
        categoryStr = @"c-domestic";
    }else if ([navLineName isEqualToString:@"当季推荐"]){
        categoryStr = @"c-season";
    }
    
    //
    NSString *actionStr;
    if ([action isEqualToString:@"更多"]) {
        actionStr = @"moreMDD";
    }else
    {
        actionStr = @"cutoverDJ";
    }
    
    
    [self sendEventWithLable:_titleArray[currentTable] andScreenName:@"频道页" andCategory:categoryStr andAction:actionStr];
}
/**
 *  无产品数据时提示文本
 */
-(void)showNoMessageLabel
{
    if (noMessageLabel == nil) {
        noMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        noMessageLabel.textAlignment = NSTextAlignmentCenter;
        noMessageLabel.text = @"暂无数据";
        noMessageLabel.textColor = [UIColor grayColor];
        noMessageLabel.font = [UIFont systemFontOfSize:15.0];
    }
    self.destinationTableView.tableFooterView = noMessageLabel;
}
/**
 *  有数据时隐藏提示文本
 */
-(void)hideNoMessageLabel
{
    if (noMessageLabel != nil) {
        
        self.destinationTableView.tableFooterView = nil;
    }
}
#pragma mark - 刷新区域
//- (void)addFooter:(UITableView *)tableView
//{
//    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self getCurrentSeasonProductDataWith:_keyWordArray[currentTable]];
//    }];
//}
- (void)addHeader:(UITableView *)tableview
{
    __weak UZDestinationChannelVC *weakSelf = self;
    UZAnimationRefreshHeader *header = [UZAnimationRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getNetworkDataWithShowLoading:NO];
    }];
    tableview.header = header;
}
-(void)endRefresh
{
    [self endRefreshWithScrollView:_destinationTableView];
}
#pragma mark -
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if ([self.travelTypeStr isEqualToString:@"国内游"] &&_zhoubianyouArray.count == 0) {
            return _rowCount-1;
        }
        
        return _rowCount;
    }else
    {
        return _currentSeasonProductArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak UZDestinationChannelVC *weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == _rowCount-1) {
            UZCurrentSeasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UZCurrentSeasonCell"];
            if (!cell) {
                cell = [[UZCurrentSeasonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UZCurrentSeasonCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        //判断是国内、出境还是当季推荐、
        if ([self.travelTypeStr isEqualToString:@"当季去哪儿"]) {
            //当季去哪儿热门目的地
            NSString *key = [NSString stringWithFormat:@"currentSeasonCell"];
            UZDestinationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
            if (cell == nil) {
                cell = [[UZDestinationTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.hideMoreButn = YES;
            cell.titleLabel.text = @"当季热门目的地";
            
            [cell setDataSourceWithArray:weakSelf.destinationArray withclassBlock:^(NSUInteger index) {
                //点击热门目的地进入列表页
                UZHomeSubClass *homeSubClass = weakSelf.destinationArray[index];
                
                UZListPageService *listPageService = [[UZListPageService alloc]init];
                UZListPageVC *listPageVC = [[UZListPageVC alloc]initWithService:listPageService];
                listPageVC.GAStr = weakSelf.GAStr;
                UZListPgeModel *listPageModel = [[UZListPgeModel alloc]init];
                listPageService.listPageModel = listPageModel;
                //1、传到列表页搜索产品必要字段---父导航
                listPageModel.preDestinationID = homeSubClass.ParentNavLinkID;
                //2、传到列表页搜索产品必要字段---目的地
                listPageModel.destination = homeSubClass.NavLinkName;
                listPageModel.searchKeyword = homeSubClass.MobileSearchKeyWord;
                listPageModel.isSearch = YES;
                //3、传到列表页搜索产品必要字段---线路类型ID
                listPageModel.travelClassID =@"0";
                //
                [weakSelf.navigationController pushViewController:listPageVC animated:YES];
            }];
            [cell reload];
            return cell;
            
        }else if ([self.travelTypeStr isEqualToString:@"国内游"])
        {
            //判断周边游有没有数据
            if (_zhoubianyouArray.count > 0) {
                //有周边游
                if (indexPath.row == 0) {
                    //国内游
                    NSString *key = [NSString stringWithFormat:@"chinaTravelCell"];
                    UZDestinationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
                    if (cell == nil) {
                        cell = [[UZDestinationTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = [NSString stringWithFormat:@"%@热门目的地",weakSelf.homeClass.subClass.NavLinkName];
                    cell.hideMoreButn = NO;
                    [cell setDataSourceWithArray:weakSelf.destinationArray withclassBlock:^(NSUInteger index) {
                        NSLog(@"当前点击:%lu",(unsigned long)index);
                        if (index == 100) {
                            //更多，进入全部目的地页面
                            
                            [self EventCountWithNavLinkName:weakSelf.homeClass.subClass.NavLinkName withAction:@"更多"];
                            
                            UZHomeClass *homeClassTemp = weakSelf.homeClass;
                            
                            UZAllDestinationVC *allDestinationVC = [[UZAllDestinationVC alloc]initWithService:weakSelf.service];
                            allDestinationVC.allHomeClass = homeClassTemp;
                            allDestinationVC.parentName = weakSelf.homeClass.subClass.NavLinkName;
                            allDestinationVC.GAStr = [NSString stringWithFormat:@"%@->%@全部目的地",weakSelf.GAStr,weakSelf.homeClass.subClass.MobileSearchKeyWord];
                            allDestinationVC.travelClassIDStr = weakSelf.travelClassIDStr;
                            allDestinationVC.title = [NSString stringWithFormat:@"%@全部目的地",weakSelf.homeClass.subClass.NavLinkName];
                            [weakSelf.navigationController pushViewController:allDestinationVC animated:YES];
                        }else
                        {
                            //点击热门目的地进入列表页
                            UZHomeSubClass *homeSubClass =  weakSelf.destinationArray[index];
                            
                            UZListPageService *listPageService = [[UZListPageService alloc]init];
                            UZListPageVC *listPageVC = [[UZListPageVC alloc]initWithService:listPageService];
                            UZListPgeModel *listPageModel = [[UZListPgeModel alloc]init];
                            listPageService.listPageModel = listPageModel;
                            listPageVC.GAStr=weakSelf.GAStr;
                            //1、传到列表页搜索产品必要字段---父导航
                            NSString *parentNavStr = @"";
                            NSString *destinationStr = @"";
                            
                            if ([homeSubClass.ParentNavLinkID isEqualToString:@"0"]) {
                                //一级导航
                                parentNavStr = homeSubClass.NavLinkName;
                                destinationStr = @"全部";
                                listPageModel.preDestinationID = homeSubClass.ID;
                                
                            }else
                            {
                                //不是一级导航
                                destinationStr = homeSubClass.NavLinkName;
                                listPageModel.preDestinationID = homeSubClass.ParentNavLinkID;
                                
                            }
                            
                            listPageModel.preDestination = parentNavStr;
                            //2、传到列表页搜索产品必要字段---目的地
                            listPageModel.destination = destinationStr;
                            listPageModel.searchKeyword = homeSubClass.MobileSearchKeyWord;
                            //3、传到列表页搜索产品必要字段---线路类型ID
                            listPageModel.travelClassID =weakSelf.travelClassIDStr;
                            //
                            [weakSelf.navigationController pushViewController:listPageVC animated:YES];
                        }
                        
                    }];
                    [cell reload];
                    return cell;
                }else if (indexPath.row == 1)
                {
                    //周边游
                    NSString *key = [NSString stringWithFormat:@"aroundTravelCell"];
                    UZDestinationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
                    if (cell == nil) {
                        cell = [[UZDestinationTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"周边游热门目的地";
                    cell.hideMoreButn = YES;
                    [cell setDataSourceWithArray:weakSelf.zhoubianyouArray withclassBlock:^(NSUInteger index) {
                        UZHomeSubClass *homeSubClass = weakSelf.zhoubianyouArray[index];
                        
                        UZListPageService *listPageService = [[UZListPageService alloc]init];
                        UZListPageVC *listPageVC = [[UZListPageVC alloc]initWithService:listPageService];
                        UZListPgeModel *listPageModel = [[UZListPgeModel alloc]init];
                        listPageService.listPageModel = listPageModel;
                        listPageVC.GAStr=weakSelf.GAStr;
                        //1、传到列表页搜索产品必要字段---父导航
                        NSString *parentNavStr = @"";
                        NSString *destinationStr = @"";
                        if ([homeSubClass.ParentNavLinkID isEqualToString:@"0"]) {
                            //一级导航
                            parentNavStr = homeSubClass.NavLinkName;
                            destinationStr = @"全部";
                            listPageModel.preDestinationID = homeSubClass.ID;
                        }else
                        {
                            //不是一级导航
                            destinationStr = homeSubClass.NavLinkName;
                            listPageModel.preDestinationID = homeSubClass.ParentNavLinkID;
                        }
                        listPageModel.preDestination = parentNavStr;
                        //2、传到列表页搜索产品必要字段---目的地
                        listPageModel.destination = destinationStr;
                        listPageModel.searchKeyword = homeSubClass.MobileSearchKeyWord;
                        //3、传到列表页搜索产品必要字段---线路类型ID
                        listPageModel.travelClassID =@"3";//周边游设置为3
                        //
                        [weakSelf.navigationController pushViewController:listPageVC animated:YES];
                    }];
                    [cell reload];
                    return cell;
                }else
                {
                    UZCurrentSeasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UZCurrentSeasonCell"];
                    if (!cell) {
                        cell = [[UZCurrentSeasonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UZCurrentSeasonCell"];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }else
            {
                //无周边游
                if (indexPath.row == 0) {
                    //国内游
                    NSString *key = [NSString stringWithFormat:@"chinaTravelCell"];
                    UZDestinationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
                    if (cell == nil) {
                        cell = [[UZDestinationTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = [NSString stringWithFormat:@"%@热门目的地",weakSelf.homeClass.subClass.NavLinkName];
                    cell.hideMoreButn = NO;
                    [cell setDataSourceWithArray:weakSelf.destinationArray withclassBlock:^(NSUInteger index) {
                        NSLog(@"当前点击:%lu",(unsigned long)index);
                        if (index == 100) {
                            //更多，进入全部目的地页面
                            
                            [self EventCountWithNavLinkName:weakSelf.homeClass.subClass.NavLinkName withAction:@"更多"];
                            
                            UZHomeClass *homeClassTemp = weakSelf.homeClass;
                            
                            UZAllDestinationVC *allDestinationVC = [[UZAllDestinationVC alloc]initWithService:weakSelf.service];
                            allDestinationVC.allHomeClass = homeClassTemp;
                            allDestinationVC.parentName = weakSelf.homeClass.subClass.NavLinkName;
                            allDestinationVC.GAStr = [NSString stringWithFormat:@"%@->%@全部目的地",weakSelf.GAStr,weakSelf.homeClass.subClass.MobileSearchKeyWord];
                            allDestinationVC.travelClassIDStr = weakSelf.travelClassIDStr;
                            allDestinationVC.title = [NSString stringWithFormat:@"%@全部目的地",weakSelf.homeClass.subClass.NavLinkName];
                            [weakSelf.navigationController pushViewController:allDestinationVC animated:YES];
                        }else
                        {
                            //点击热门目的地进入列表页
                            UZHomeSubClass *homeSubClass =  weakSelf.destinationArray[index];
                            
                            UZListPageService *listPageService = [[UZListPageService alloc]init];
                            UZListPageVC *listPageVC = [[UZListPageVC alloc]initWithService:listPageService];
                            UZListPgeModel *listPageModel=[[UZListPgeModel alloc]init];
                            listPageService.listPageModel = listPageModel;
                            listPageVC.GAStr=weakSelf.GAStr;
                            //1、传到列表页搜索产品必要字段---父导航
                            NSString *parentNavStr = @"";
                            NSString *destinationStr = @"";
                            if ([homeSubClass.ParentNavLinkID isEqualToString:@"0"]) {
                                //一级导航
                                parentNavStr = homeSubClass.NavLinkName;
                                destinationStr = @"全部";
                                listPageModel.preDestinationID = homeSubClass.ID;
                            }else
                            {
                                //不是一级导航
                                destinationStr = homeSubClass.NavLinkName;
                                listPageModel.preDestinationID = homeSubClass.ParentNavLinkID;
                            }
                            
                            listPageModel.preDestination = parentNavStr;
                            //2、传到列表页搜索产品必要字段---目的地
                            listPageModel.destination = destinationStr;
                            listPageModel.searchKeyword = homeSubClass.MobileSearchKeyWord;
                            //3、传到列表页搜索产品必要字段---线路类型ID
                            listPageModel.travelClassID =weakSelf.travelClassIDStr;
                            //
                            [weakSelf.navigationController pushViewController:listPageVC animated:YES];
                        }
                        
                    }];
                    [cell reload];
                    return cell;
                }else
                {
                    UZCurrentSeasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UZCurrentSeasonCell"];
                    if (!cell) {
                        cell = [[UZCurrentSeasonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UZCurrentSeasonCell"];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
        }else
        {
            //出境游
            NSString *key = [NSString stringWithFormat:@"nationalTravelCell"];
            UZDestinationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
            if (cell == nil) {
                cell = [[UZDestinationTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = [NSString stringWithFormat:@"%@热门目的地",_homeClass.subClass.NavLinkName];
            cell.hideMoreButn = NO;
            [cell setDataSourceWithArray:weakSelf.destinationArray withclassBlock:^(NSUInteger index) {
                if (index == 100) {
                    //更多，进入全部目的地页面
                    UZHomeClass *homeClassTemp = weakSelf.homeClass;
                    [self EventCountWithNavLinkName:weakSelf.homeClass.subClass.NavLinkName withAction:@"更多"];
                    UZAllDestinationVC *allDestinationVC = [[UZAllDestinationVC alloc]initWithService:weakSelf.service];
                    allDestinationVC.allHomeClass = homeClassTemp;
                    allDestinationVC.parentName = weakSelf.homeClass.subClass.NavLinkName;
                    allDestinationVC.travelClassIDStr = weakSelf.travelClassIDStr;
                    allDestinationVC.title = [NSString stringWithFormat:@"%@全部目的地",weakSelf.homeClass.subClass.NavLinkName];
                    allDestinationVC.GAStr = [NSString stringWithFormat:@"%@->%@全部目的地",weakSelf.GAStr,weakSelf.homeClass.subClass.MobileSearchKeyWord];
                    [weakSelf.navigationController pushViewController:allDestinationVC animated:YES];
                }else
                {
                    //点击热门目的地进入列表页
                    UZHomeSubClass *homeSubClass =  weakSelf.destinationArray[index];
                    
                    UZListPageService *listPageService = [[UZListPageService alloc]init];
                    UZListPageVC *listPageVC = [[UZListPageVC alloc]initWithService:listPageService];
                    listPageVC.GAStr = weakSelf.GAStr;
                    UZListPgeModel *listPageModel = [[UZListPgeModel alloc]init];
                    listPageService.listPageModel = listPageModel;
                    //1、传到列表页搜索产品必要字段---父导航
                    NSString *parentNavStr = @"";
                    NSString *destinationStr = @"";
                    if ([homeSubClass.ParentNavLinkID isEqualToString:@"0"]) {
                        //一级导航
                        parentNavStr = homeSubClass.NavLinkName;
                        destinationStr = @"全部";
                        listPageModel.preDestinationID = homeSubClass.ID;
                    }else
                    {
                        //不是一级导航
                        destinationStr = homeSubClass.NavLinkName;
                        listPageModel.preDestinationID = homeSubClass.ParentNavLinkID;
                    }
                    
                    listPageModel.preDestination = parentNavStr;
                    //2、传到列表页搜索产品必要字段---目的地
                    listPageModel.destination = destinationStr;
                    listPageModel.searchKeyword = homeSubClass.MobileSearchKeyWord;
                    //3、传到列表页搜索产品必要字段---线路类型ID
                    listPageModel.travelClassID =weakSelf.travelClassIDStr;
                    //
                    [weakSelf.navigationController pushViewController:listPageVC animated:YES];
                }
                
            }];
            [cell reload];
            return cell;
        }
        
    }else
    {
        static NSString *identifer=@"listPageCellidentifer";
        UZListPageCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell=[[UZListPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UZListPageProductModel *productModel;
        productModel = _currentSeasonProductArray[indexPath.row];
        [cell setData1:productModel];
        
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_zhoubianyouArray.count == 0 && [self.travelTypeStr isEqualToString:@"国内游"]) {
            if (indexPath.row == 0) {
                NSInteger flag = _destinationArray.count>3?2:1;
                return flag*(81*KDestinationScale750+32)+47+12*KDestinationScale750;
            }else
            {
                return 47;
            }
        }else
        {
            if (indexPath.row == _rowCount-1) {
                return 47;
            }else if (indexPath.row == 0){
                NSInteger flag = _destinationArray.count>3?2:1;
                return flag*(81*KDestinationScale750+32)+47+12*KDestinationScale750;
            }else
            {
                //周边游
                NSInteger flag = _zhoubianyouArray.count>3?2:1;
                return flag*(81*KDestinationScale750+32)+47+12*KDestinationScale750;
            }
        }
    }else
    {
        return 113;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //推荐产品
        UZListPageProductModel *productModel = _currentSeasonProductArray[indexPath.row];
        //标记已读
        productModel.isRead = YES;
        
        NSString *destination=_keyWordArray[currentTable];
        UZProductService *service1 = [[UZProductService alloc]init];
        service1.productId=productModel.productID;
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"UZProductInfoVC" bundle:[NSBundle mainBundle]];
        UZProductInfoVC *productDetailVC=[storyBoard instantiateViewControllerWithIdentifier:@"ProductInfoVC"];
        if ([productModel.productType isEqualToString:@"跟团游"]){
            service1.uzaiProductClassId=@"跟团游";
            productDetailVC.GAStr=[NSString stringWithFormat:@"%@->%@跟团产品页",self.GAStr,destination];
        }
        else{
            service1.uzaiProductClassId=@"自由行";
            productDetailVC.GAStr=[NSString stringWithFormat:@"%@->%@自由产品页",self.GAStr,destination];
        }
        
        productDetailVC.service=service1;
        
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47)];
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:_titleArray];
    segmentedControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 47);
    segmentedControl.selectedIndex = currentTable;
    segmentedControl.selectionIndicatorMode=HMSelectionIndicatorFillsSegment;
    segmentedControl.selectionIndicatorColor=[UIColor ColorRGBWithString:@"#f93868"];
    segmentedControl.textColor=[UIColor ColorRGBWithString:@"#333333"];
    segmentedControl.backgroundColor=[UIColor whiteColor];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTag:1];
    [segmentView addSubview:segmentedControl];
    
    return segmentView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 47;
    }
    return 0;
}
-(void)segmentedControlChangedValue:(HMSegmentedControl *)segment
{
    currentTable=segment.selectedIndex;
    //切换数据源,重新调用搜索接口，传递新的关键字参数
    
    if ([self.travelTypeStr isEqualToString:@"当季去哪儿"]) {
        [self EventCountWithNavLinkName:@"当季推荐" withAction:@""];
    }else
    {
        [self EventCountWithNavLinkName:_homeClass.subClass.NavLinkName withAction:@""];
    }
    
    
    [self getCurrentSeasonProductDataWith:_keyWordArray[segment.selectedIndex] withShowLoaing:YES];
}
-(void)dealloc
{
    self.destinationArray = nil;
    self.currentSeasonProductArray = nil;
    self.titleArray = nil;
    self.keyWordArray = nil;
    self.destinationTableView = nil;
    self.service = nil;
    self.homeClass = nil;
    self.cache = nil;
    self.zhoubianyouArray = nil;
    self.travelClassIDStr = nil;
    self.travelTypeStr = nil;
    self.field2Str = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
