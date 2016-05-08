//
//  UZListPageVC.m
//  UZai5.2
//
//  Created by uzai on 14-9-10.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZListPageVC.h"
#import "NSString+Expand.h"
#import "HMSegmentedControl.h"
#import "UIColor+RGBString.h"
#import "UZListPageCell.h"
#import "UZListPagePicker.h"
#import "UZDestinationPicker.h"
#import "UZProductDetailList.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "UZProdcutWebVC.h"
#import "UZProductService.h"
#import "UZPreDestination.h"
#import "UZProductInfoVC.h"
#import "AFSwipeToHide.h"
#import "UZListPageFooterView.h"
#import "UZHomeClass.h"
#import "UZSearchPoint.h"
#import "UZListPageProductModel.h"
#import <mach/mach_time.h>

@interface UZListPageVC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,AFSwipeToHideDelegate>
{
    UITableView *tableViewAll;     //全部
    UITableView *tableViewGroupTourist;  //跟团游
    UITableView *tableViewBicycleTourism;  //自行游
    
    NSMutableArray *arrayWithAll;
    NSMutableArray *arrayWithGroupTourist;
    NSMutableArray *arrayWithBicycleTourism;
    
    int pageAll;
    int pageGroupTourist;
    int pageBicycleTourism;
    
    UZCity *startCity;
    
    UZListPagePicker *listPagePicker;//高级筛选
    UZDestinationPicker *destinationPicker;//目的地
    
    NSString *GAStrPer;
    
    AFSwipeToHide *swipeToHide;
    
}
@property (nonatomic,copy) NSString *travelWay;//查询线路有哪些类型(1跟团游；2自由行，0全部,-1无数据)
@property (strong, nonatomic) IBOutlet HMSegmentedControl *segmentType;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic)  UZListPageFooterView *viewWIthFooter;

@end

@implementation UZListPageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithService:(UZListPageService *)service
{
    self=[super init];
    if (self) {
        _service=service;
        arrayWithAll=[NSMutableArray arrayWithCapacity:0];
        arrayWithBicycleTourism=[NSMutableArray arrayWithCapacity:0];
        arrayWithGroupTourist=[NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [tableViewAll reloadData];
    [tableViewBicycleTourism reloadData];
    [tableViewGroupTourist reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:self.title];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.title];
}
-(void)setTitleTextView
{
    NSString *desination = [self getDetinationStr];
    if (desination.length==0&&[_service.listPageModel.travelClassID isEqualToString:@"238"]) {
        desination = @"邮轮";
    }
    self.title = [NSString stringWithFormat:@"%@  产品",desination];
}


double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /  (double)timebase.denom / 1e9;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([_service.listPageModel.travelClassID isEqualToString:@"4"]) {
        _service.listPageModel.orderBy=2;
    }
    if (_service.listPageModel.city) {
        startCity=_service.listPageModel.city;
    }else
    {
        startCity=UZ_CLIENT.city;
    }
    GAStrPer = [self getGADestination];
    [self sendViewNameWithName:[NSString stringWithFormat:@"%@->%@列表页",self.GAStr,GAStrPer]];
    
    [self setTitleTextView];
    
    destinationPicker=[[UZDestinationPicker alloc]initWithService:_service];
    listPagePicker=[[UZListPagePicker alloc]initWithService:_service];
    
    //初始化选项卡
    _segmentType = [[HMSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"全部",@"跟团游",@"自由行", nil]];
    _segmentType.selectionIndicatorMode=HMSelectionIndicatorFillsSegment;
    _segmentType.selectionIndicatorColor=[UIColor ColorRGBWithString:bgWithTextColor];
    _segmentType.frame=CGRectMake(0, 0, App_Frame_Width, 47);
    _segmentType.backgroundColor=[UIColor whiteColor];
    [_segmentType addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [_segmentType setTag:1];
    [self.view addSubview:_segmentType];
    _segmentType.hidden = YES;
    
    //设置滚动视图
    self.myScrollView.frame=CGRectMake(0, 0, App_Frame_Width, App_Frame_Height-47-50);
    self.myScrollView.contentSize=CGSizeMake(App_Frame_Width*3, self.myScrollView.frame.size.height);
    self.myScrollView.delegate=self;
    
    //设置tablview
    CGRect frame=self.myScrollView.frame;
    frame.origin.y=0;
    tableViewAll=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    frame.origin.x=App_Frame_Width;
    tableViewAll.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableViewGroupTourist=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    frame.origin.x=App_Frame_Width*2;
    tableViewGroupTourist.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableViewBicycleTourism=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableViewBicycleTourism.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableViewAll.delegate=self;
    tableViewAll.dataSource=self;
    tableViewGroupTourist.delegate=self;
    tableViewGroupTourist.dataSource=self;
    tableViewBicycleTourism.delegate=self;
    tableViewBicycleTourism.dataSource=self;
    
    tableViewAll.backgroundColor = [UIColor clearColor];
    tableViewBicycleTourism.backgroundColor = [UIColor clearColor];
    tableViewGroupTourist.backgroundColor = [UIColor clearColor];
    [self.myScrollView addSubview:tableViewAll];
    [self.myScrollView addSubview:tableViewGroupTourist];
    [self.myScrollView addSubview:tableViewBicycleTourism];
    
    [self addHeader:tableViewAll];
    [self addFooter:tableViewAll];
    
    [self addHeader:tableViewBicycleTourism];
    [self addFooter:tableViewBicycleTourism];
    
    [self addHeader:tableViewGroupTourist];
    [self addFooter:tableViewGroupTourist];
    
    swipeToHide = [[AFSwipeToHide alloc] init];
    swipeToHide.scrollDistance = 20;
    swipeToHide.delegate = self;
    
    tableViewAll.delegate = (id<UITableViewDelegate>)swipeToHide;
    tableViewBicycleTourism.delegate = (id<UITableViewDelegate>)swipeToHide;
    tableViewGroupTourist.delegate = (id<UITableViewDelegate>)swipeToHide;

    self.viewWIthFooter = [[UZListPageFooterView alloc]initWithFrame:CGRectMake(0, App_Frame_Height-50-44, App_Frame_Width, 50)];
    self.viewWIthFooter.service = _service;
    [self.viewWIthFooter setShowDesination:!(_service.listPageModel.isSearch||_service.listPageModel.isProductSearch)];

    [self.view addSubview:self.viewWIthFooter];
    
    __weak UZListPageVC *weakSelf = self;
    __block UZDestinationPicker *blockDestinationPicker = destinationPicker;
    __block UZListPagePicker *blockListPagePicker = listPagePicker;
    
   __block uint64_t begin = mach_absolute_time();
    [self.viewWIthFooter selectIndex:^(NSInteger selectIndex) {
        
        
        uint64_t end = mach_absolute_time();
        
        if (MachTimeToSecs(end - begin)<=0.5) {
            
            return;
        }
        
        begin = mach_absolute_time();
        
        if (selectIndex==0) {
            
            if (blockDestinationPicker.showState) {
                [blockDestinationPicker hideWithStr:nil];
            }else
            {
                blockDestinationPicker.service=weakSelf.service;
                [weakSelf sendEventWithLable:[weakSelf travelGACutOver] andScreenName:@"线路列表页" andCategory:[weakSelf travelGAStrCategory] andAction:[weakSelf travelGACutOver]];
                [blockDestinationPicker showWithOnClick:^(id data) {

                    if (data) {
                        weakSelf.service.listPageModel.searchKeyword=data;
                        if (weakSelf.service.listPageModel.searchKeyword.length!=0) {
                            [weakSelf showLoadingWithMessage:nil];
                            [weakSelf refreshTableViewAll];
                            
                            [weakSelf sendEventWithLable:weakSelf.service.listPageModel.preDestination andScreenName:@"线路列表页" andCategory:[weakSelf travelGAStrCategory] andAction:[weakSelf travelGACutOver]];
                            
                            [weakSelf sendEventWithLable:@"confirm" andScreenName:@"线路列表" andCategory:[weakSelf travelGAStrCategory] andAction:[weakSelf travelGACutOver]];
                        }
                        [weakSelf setTitleTextView];
                    }else
                    {
                        [weakSelf sendEventWithLable:@"cancel" andScreenName:@"线路列表" andCategory:[weakSelf travelGAStrCategory] andAction:[weakSelf travelGACutOver]];
                    }
                    
                    if (blockListPagePicker.showState) {
                        [weakSelf.viewWIthFooter reload];
                    }else
                    {
                        [weakSelf.viewWIthFooter reset];
                    }
                }];
                
                if (blockListPagePicker.showState) {
                    [blockListPagePicker hiden:nil];
                }
            }
        }
        else if (selectIndex==1)
        {
            if (blockDestinationPicker.showState) {
                [blockDestinationPicker hideWithStr:nil];
            }
            if (blockListPagePicker.showState) {
                [blockListPagePicker hiden:nil];
            }
            [weakSelf showLoadingWithMessage:nil];
            [weakSelf refreshCurrent];
            [weakSelf sendSortGAEvent];
        }
        else if (selectIndex==2)
        {
            if (blockDestinationPicker.showState) {
                [blockDestinationPicker hideWithStr:nil];
            }
            if (blockListPagePicker.showState) {
                [blockListPagePicker hiden:nil];
            }
            [weakSelf showLoadingWithMessage:nil];
            [weakSelf refreshCurrent];
            [weakSelf sendSortGAEvent];
        }else
        {
            if (blockListPagePicker.showState) {
                [blockListPagePicker hiden:nil];
            }
            else
            {
                blockListPagePicker.service=weakSelf.service;
                blockListPagePicker.listPageVC = weakSelf;
                [blockListPagePicker showWithOnClick:^(id data) {
                    if (data) {
                        [weakSelf showLoadingWithMessage:nil];
                        [weakSelf refreshCurrent];
                    }
                    if (blockDestinationPicker.showState) {
                        [weakSelf.viewWIthFooter reload];
                    }else
                    {
                        [weakSelf.viewWIthFooter reset];
                    }
    
                }];
                
                if (blockDestinationPicker.showState) {
                    [blockDestinationPicker hideWithStr:nil];
                }
                
                [weakSelf sendEventWithLable:@"filter" andScreenName:@"线路列表" andCategory:[weakSelf travelGAStrCategory] andAction:@"filter"];
            }
        }
    }];
    
    if (_service.listPageModel.isSearch||_service.listPageModel.isProductSearch) {
  
        [self loadDataIsLoadMore:NO withTableView:tableViewAll];
    }else
    {
        [self requestCityList];
    }
}

-(void)sendSortGAEvent
{
//    1推荐热门，2价格升序，3销量降序，4推荐冷门，5价格降序，6，销售量升序）
    if (self.service.listPageModel.orderBy == 1) {
        [self sendEventWithLable:@"默认排序" andScreenName:@"线路列表" andCategory:[self travelGAStrCategory] andAction:@"arrayPrice"];
    }else if (self.service.listPageModel.orderBy == 2)
    {
        [self sendEventWithLable:@"价格从低到高排" andScreenName:@"线路列表" andCategory:[self travelGAStrCategory] andAction:@"arrayPrice"];
    }else if (self.service.listPageModel.orderBy == 5)
    {
        [self sendEventWithLable:@"价格从高到低排" andScreenName:@"线路列表" andCategory:[self travelGAStrCategory] andAction:@"arrayPrice"];
    }else if (self.service.listPageModel.orderBy == 3)
    {
        [self sendEventWithLable:@"销量从高到低排" andScreenName:@"线路列表" andCategory:[self travelGAStrCategory] andAction:@"arraySales"];
    }
}
#pragma mark - AFUSwipeToHide delegate

- (void)swipeToHide:(AFSwipeToHide *)SwipeToHide didUpdatePercentHiddenInteractively:(BOOL)interactive andScrollView:(UIScrollView *)scrollView {
    CGFloat percentHidden = SwipeToHide.percentHidden;
    //数量少时，不动画
    if ((tableViewAll.contentSize.height<tableViewAll.bounds.size.height&&tableViewAll==scrollView)||(tableViewBicycleTourism.contentSize.height<tableViewBicycleTourism.bounds.size.height&&tableViewBicycleTourism==scrollView)||(tableViewGroupTourist.contentSize.height<tableViewGroupTourist.bounds.size.height&&tableViewGroupTourist==scrollView)) {
        return;
    }
    [self hiddenBottomView:percentHidden didUpdatePercentHiddenInteractively:interactive andScrollView:scrollView];
}
-(void)hiddenBottomView:(CGFloat)percentHidden didUpdatePercentHiddenInteractively:(BOOL)interactive andScrollView:(UIScrollView *)scrollView
{
    __block UZListPageVC *blockSelf = self;
    
    [UIView animateWithDuration:(percentHidden==0||interactive)?0.2:0 animations:^{
        
        BOOL isShowTop = [blockSelf.travelWay integerValue]==0;
        blockSelf.viewWIthFooter.frame = CGRectMake(0, HEIGHT(blockSelf.view)-HEIGHT(blockSelf.viewWIthFooter)+HEIGHT(blockSelf.viewWIthFooter)*percentHidden, WIDTH(blockSelf.viewWIthFooter), HEIGHT(blockSelf.viewWIthFooter));
        
        blockSelf.myScrollView.frame=CGRectMake(0, isShowTop?47:0, App_Frame_Width,App_Frame_Height-44-HEIGHT(blockSelf.viewWIthFooter)+percentHidden*HEIGHT(blockSelf.viewWIthFooter)-(isShowTop?47:0));
        blockSelf.myScrollView.contentSize=CGSizeMake(App_Frame_Width*3, blockSelf.myScrollView.frame.size.height);
        for (UIView *view in blockSelf.myScrollView.subviews) {
            if ([view isMemberOfClass:[UITableView class]]) {
                CGRect frame=view.frame;
                frame.size.height=blockSelf.myScrollView.frame.size.height;
                view.frame=frame;
            }
        }
    } completion:^(BOOL finished) {
        
    }];
}

-(void)swipeToHide:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UZListPageProductModel *productModel;
    if (tableView==tableViewAll) {
        productModel=arrayWithAll[indexPath.row];
    }else if (tableView==tableViewBicycleTourism)
    {
        productModel=arrayWithBicycleTourism[indexPath.row];
    }else
    {
        productModel=arrayWithGroupTourist[indexPath.row];
    }
    //标记已读
    productModel.isRead = YES;
    
    NSString *destination=[self getGADestination];
    UZProductService *service1=[[UZProductService alloc]init];
    service1.productId=productModel.productID;
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"UZProductInfoVC" bundle:[NSBundle mainBundle]];
    UZProductInfoVC *productDetailVC=[storyBoard instantiateViewControllerWithIdentifier:@"ProductInfoVC"];
    productDetailVC.hidesBottomBarWhenPushed=YES;
    if ([productModel.productType isEqualToString:@"跟团游"]){
        service1.uzaiProductClassId=@"跟团游";
        productDetailVC.GAStr=[NSString stringWithFormat:@"%@->%@列表页->%@跟团产品页",self.GAStr,GAStrPer,destination];
    }
    else{
        service1.uzaiProductClassId=@"自由行";
        productDetailVC.GAStr=[NSString stringWithFormat:@"%@->%@列表页->%@自由产品页",self.GAStr,GAStrPer,destination];
    }
    
    productDetailVC.service=service1;
    
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

-(NSString *)getDetinationStr
{
    NSString *destination=[_service.listPageModel.destination isEqualToString:@"全部"]?_service.listPageModel.preDestination:_service.listPageModel.destination;
    if (destination.length==0) {
        return @"";
    }
    
    return destination;
}
#pragma mark - 刷新区域
- (void)addFooter:(UITableView *)tableView
{
    __weak UZListPageVC *weakSelf = self;
    __block UITableView *blockTableView = tableView;
     tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataIsLoadMore:YES withTableView:blockTableView];
    }];
}
- (void)addHeader:(UITableView *)tableview
{
    __weak UZListPageVC *weakSelf = self;
    __block UITableView *blockTableView = tableview;
    UZAnimationRefreshHeader *header = [UZAnimationRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataIsLoadMore:NO withTableView:blockTableView];
    }];
    tableview.header = header;
}

//重新加载全部类别
-(void)refreshTableViewAll
{
    [arrayWithAll removeAllObjects];
    [arrayWithBicycleTourism removeAllObjects];
    [arrayWithGroupTourist removeAllObjects];
    [tableViewAll reloadData];
    [tableViewBicycleTourism reloadData];
    [tableViewGroupTourist reloadData];
    [self loadDataIsLoadMore:NO withTableView:tableViewAll];
    [self.segmentType setSelectedIndex:0 animated:YES];
}

////所有重新加载
//-(void)refresh
//{
//    [self loadDataIsLoadMore:NO withTableView:tableViewAll];
//    [self loadDataIsLoadMore:NO withTableView:tableViewBicycleTourism];
//    [self loadDataIsLoadMore:NO withTableView:tableViewGroupTourist];
//}
-(void)refreshCurrent
{
    [arrayWithAll removeAllObjects];
    [arrayWithBicycleTourism removeAllObjects];
    [arrayWithGroupTourist removeAllObjects];
    [tableViewAll reloadData];
    [tableViewBicycleTourism reloadData];
    [tableViewGroupTourist reloadData];
    
    if (self.segmentType.selectedIndex==0) {
         [self loadDataIsLoadMore:NO withTableView:tableViewAll];
    }else if (self.segmentType.selectedIndex==1)
    {
        [self loadDataIsLoadMore:NO withTableView:tableViewGroupTourist];
    }else
    {
        [self loadDataIsLoadMore:NO withTableView:tableViewBicycleTourism];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tableViewAll) {
        return arrayWithAll.count;
    }else if(tableView==tableViewBicycleTourism)
    {
        return arrayWithBicycleTourism.count;
    }
    return arrayWithGroupTourist.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"listPageCellidentifer";
    UZListPageCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell=[[UZListPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    UZListPageProductModel *productModel;
    if (tableView==tableViewAll) {
        productModel=arrayWithAll[indexPath.row];
    }else if (tableView==tableViewBicycleTourism)
    {
        productModel=arrayWithBicycleTourism[indexPath.row];
    }else
    {
        productModel=arrayWithGroupTourist[indexPath.row];
    }
 
    [cell setData1:productModel];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_myScrollView) {
        int currentPage = floor((scrollView.contentOffset.x - Main_Screen_Width / 2) / Main_Screen_Width) + 1;
        if(_segmentType.selectedIndex != currentPage)
        {
            [_segmentType setSelectedIndex:currentPage animated:YES];
        }
    }
}

-(void)segmentedControlChangedValue:(HMSegmentedControl *)segment
{
    [_myScrollView setContentOffset:CGPointMake(App_Frame_Width*segment.selectedIndex, 0) animated:YES];
    if (segment.selectedIndex == 0) {
          [self hiddenBottomView:0 didUpdatePercentHiddenInteractively:YES andScrollView:tableViewAll];
    }else if (segment.selectedIndex == 1)
    {
      [self hiddenBottomView:0 didUpdatePercentHiddenInteractively:YES andScrollView:tableViewGroupTourist];
    }else
    {
        [self hiddenBottomView:0 didUpdatePercentHiddenInteractively:YES andScrollView:tableViewBicycleTourism];
    }
  
    NSArray *array=@[@"全部",@"跟团游",@"自由行"];
    [self sendEventWithLable:array[segment.selectedIndex] andScreenName:@"线路列表页" andCategory:[self travelGAStrCategory] andAction:@"cutoverQGZ"];
    
    if (segment.selectedIndex==0 && arrayWithAll.count == 0) {
        [self loadDataIsLoadMore:NO withTableView:tableViewAll];
    }
    if (segment.selectedIndex ==1 && arrayWithGroupTourist.count == 0) {
            [self loadDataIsLoadMore:NO withTableView:tableViewGroupTourist];
    }
    if (segment.selectedIndex == 2 && arrayWithBicycleTourism.count == 0) {
        [self loadDataIsLoadMore:NO withTableView:tableViewBicycleTourism];
    }
    
    if ((segment.selectedIndex==0 && arrayWithAll.count > 0)||(segment.selectedIndex ==1 && arrayWithGroupTourist.count > 0) || (segment.selectedIndex == 2 && arrayWithBicycleTourism.count > 0)) {
        [self hideNoMessage];
    }
}

#pragma mark 加载网络数据
-(void)loadDataIsLoadMore:(BOOL)flag withTableView:(UITableView *)tableView
{
    int startIndex=1;
    int querType = 0;
    if (tableView==tableViewAll) {
        startIndex=pageAll;
        querType=0;
    }
    if (tableView==tableViewBicycleTourism) {
        startIndex=pageBicycleTourism;
        querType=2;
    }
    if (tableView==tableViewGroupTourist) {
        startIndex=pageGroupTourist;
        querType=1;
    }
    
    NSString *destination=[self getDestination];
    NSString *days=[self getDaysWithIndex:_service.listPageModel.dayRangeID] ;
    NSString *priceRange=[self getPriceWithIndex:_service.listPageModel.priceRangeID];
    NSUInteger orderBy=_service.listPageModel.orderBy;
    NSUInteger diamond=_service.listPageModel.diamond;
    
    NSString *goDateCondition=[self dateFormat:_service.listPageModel.goDateCondition];
    goDateCondition = goDateCondition.length==0?@"":goDateCondition;
    NSString *keyword;
    if ([_service.listPageModel.travelClassID isEqualToString:@"238"]) {
        keyword = _service.listPageModel.preDestinationSearchKeyword;
    }else if ([_service.listPageModel.travelClassID isEqualToString:@"9896"])
    {
        keyword=@"海岛";
    }
    __weak UZListPageVC *weakSelf = self;
    
    if(flag)
    {
        [self.service getProductListWithUserID:UZ_CLIENT.UserID andTravelClassID:[_service.listPageModel.travelClassID integerValue] andSearchContent:destination andProductType:querType andGoDate:goDateCondition andDays:days andPrice:priceRange andDiamond:diamond andKeyword:keyword andStartIndex:startIndex andCount:15 andOrderBy:orderBy SuccessBlock:^(NSArray *productList, NSUInteger total, NSString *travelWay) {
            if(productList.count==0)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    [tableView setFooter:nil];
                }];
            }
            [self endRefresh];
            if (tableView==tableViewAll) {
                pageAll++;
                [arrayWithAll addObjectsFromArray:productList];
            }
            if (tableView==tableViewBicycleTourism) {
                pageBicycleTourism++;
                [arrayWithBicycleTourism addObjectsFromArray:productList];
            }
            if (tableView==tableViewGroupTourist) {
                pageGroupTourist++;
                [arrayWithGroupTourist addObjectsFromArray:productList];
            }
            [tableView reloadData];
        } withFiledBlock:^(NSString *code, NSString *msg) {
            [weakSelf endRefresh];
            [weakSelf hideLoading];
        }];
    }else{
        if (arrayWithAll.count==0) {
            tableViewAll.hidden=YES;
        }
        if ((tableView==tableViewAll&&arrayWithAll.count==0) || (tableView==tableViewBicycleTourism&&arrayWithBicycleTourism.count==0 )|| (tableView==tableViewGroupTourist && arrayWithGroupTourist.count == 0)) {
            [weakSelf hideNoMessage];
            [weakSelf showLoadingWithMessage:nil];
        }
    
        [self.service getProductListWithUserID:UZ_CLIENT.UserID andTravelClassID:[_service.listPageModel.travelClassID integerValue] andSearchContent:destination andProductType:querType andGoDate:goDateCondition andDays:days andPrice:priceRange andDiamond:diamond andKeyword:keyword andStartIndex:1 andCount:15 andOrderBy:orderBy SuccessBlock:^(NSArray *productList, NSUInteger total, NSString *travelWay) {
            weakSelf.travelWay =travelWay;
            tableViewAll.hidden=NO;
            
            [weakSelf hideLoading];
            [weakSelf endRefresh];
            if (tableView.footer==nil) {
                [weakSelf addFooter:tableView];
            }
            if (tableView==tableViewAll) {
                pageAll=2;
                tableViewAll.dataSource = nil;
                [arrayWithAll removeAllObjects];
                [arrayWithAll addObjectsFromArray:productList];
                tableViewAll.dataSource = self;
                [tableView reloadData];
                if (arrayWithAll.count==0) {
                    tableViewAll.hidden=YES;
                    self.segmentType.hidden=YES;
                    self.myScrollView.scrollEnabled=NO;
                }else
                {
                    tableViewAll.hidden=NO;
                    [weakSelf hideNoMessage];
                    
                    //数据不为空时将搜索文本添加到历史搜索中
                    if (_service.listPageModel.isSearch&&[_service.listPageModel.travelClassID integerValue]==0) {
                        [UZSearchPoint insertCityList:_service.listPageModel.destination];
                    }
                    [weakSelf isShowTopBarWithIsAllShow:[weakSelf.travelWay integerValue]==0];
                }
                
            }
            if (tableView==tableViewBicycleTourism) {
                pageBicycleTourism=2;
                [arrayWithBicycleTourism removeAllObjects];
                [arrayWithBicycleTourism addObjectsFromArray:productList];
                [tableView reloadData];
            }
            if (tableView==tableViewGroupTourist) {
                pageGroupTourist=2;
                [arrayWithGroupTourist removeAllObjects];
                [arrayWithGroupTourist addObjectsFromArray:productList];
                [tableView reloadData];
            }
            
            [tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            if (weakSelf.segmentType.selectedIndex==1&&arrayWithGroupTourist.count>0) {
                [weakSelf hideNoMessage];
            }else if (weakSelf.segmentType.selectedIndex==2&&arrayWithBicycleTourism.count>0)
            {
                [weakSelf hideNoMessage];
            }else if (weakSelf.segmentType.selectedIndex==0&&arrayWithAll.count>0)
            {
                [weakSelf hideNoMessage];
            }else
            {
                [weakSelf showNoMessage:[UIImage imageNamed:@"bg_nolistpage"] withText:@"暂无相关信息"];
            }

        } withFiledBlock:^(NSString *code, NSString *msg) {
            [weakSelf endRefresh];
            [weakSelf hideLoading];
            if (arrayWithAll.count==0&&tableView==tableViewAll) {
                [weakSelf showLoadFailedWithBlock:^{
                    [weakSelf loadDataIsLoadMore:flag withTableView:tableView];
                }];
            }
        }];
    }
   
    return;
}
-(void)endRefresh
{
    [self endRefreshWithScrollView:tableViewAll];
    [self endRefreshWithScrollView:tableViewBicycleTourism];
    [self endRefreshWithScrollView:tableViewGroupTourist];
}
-(NSString *)getDaysWithIndex:(NSUInteger)index
{
    NSArray *arrayDays = @[@"1-2",@"3-5",@"6-8",@"9-11",@"12-?"];
    if (index==0) {
        return @"";
    }
    return arrayDays[index-1];
}
-(NSString *)getPriceWithIndex:(NSUInteger)index
{
    NSArray *arrayWithPrice = @[@"1-500",@"501-1000",@"1001-3000",@"3001-5000",@"5001-8000",@"8001-10000",@"10001-?"];
    if (index==0) {
        return @"";
    }
    return arrayWithPrice[index-1];
}
-(NSString *)dateFormat:(NSString *)str
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *strDate=[[str componentsSeparatedByString:@" "]objectAtIndex:0];
    NSDate *date=[formatter dateFromString:strDate];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    if (!date) {
        [formatter setDateFormat:@"yyyy年MM月"];
        date=[formatter dateFromString:strDate];
        [formatter setDateFormat:@"yyyy/MM/?"];
    }
    return [formatter stringFromDate:date];
}
-(NSString *)getDestinationPer
{
    NSString *destination;
    if ([_service.listPageModel.destination isEqualToString:@"全部"]) {
        destination = _service.listPageModel.preDestination.length == 0 ? _service.listPageModel.searchKeyword : _service.listPageModel.preDestination;
    }else
    {
        destination = _service.listPageModel.destination.length == 0 ? _service.listPageModel.searchKeyword : _service.listPageModel.destination;
    }
    return destination;
}
-(NSString *)getDestination
{
    NSString *destination = [self getDestinationPer];
    destination = [NSString stringWithFormat:@"%@",destination.length==0?@"":destination];
    destination = _service.listPageModel.searchKeyword.length==0?destination:_service.listPageModel.searchKeyword;
    return destination;
}
-(NSString *)getGADestination
{
    NSString *destination = [self getDestinationPer];
    
    if ([_service.listPageModel.travelClassID integerValue]==0) {
        //搜索
        return @"搜索结果";
    }
    if ([_service.listPageModel.travelClassID integerValue]==9896) {
        //海岛
        return @"海岛";
    }
    return destination.length>0?destination:[self travelStrWithTraveID:_service.listPageModel.travelClassID];
    
    return destination;
}
-(void)requestCityList
{
    [self showLoadingWithMessage:nil];
//    出境游导航 = 1,
//    国内游一级导航 = 2,
//    国内游二级导航 = 3,
//    周边游导航 = 4,
//    游轮游导航 = 5,
//    当季去哪玩 = 6,
    NSInteger linkType = 1;
    //线路类型ID（1 为“出境游”，2为“国内游”，3为“周边游”，4为 “当地游”，238为 “邮轮游”，0为搜索

    if ([_service.listPageModel.travelClassID integerValue]==1) {
        linkType = 1;
    }else if([_service.listPageModel.travelClassID integerValue]==2) {
        linkType = 3;
    }else if([_service.listPageModel.travelClassID integerValue]==3) {
        linkType = 4;
    }else if([_service.listPageModel.travelClassID integerValue]==238) {
        linkType = 5;
    }
    
    __block UZListPageVC *blockSelf =self;
    [_service getDestinationChannelDataWithNavLinkType:linkType withNavLinkID:0 withHotNavEnable:0 withSaveData:@"1900-01-01 00:00" withSuccessBlock:^(NSArray *messageList, NSString *lastTime) {
        if (!blockSelf.service.listPageCityList) {
            blockSelf.service.listPageCityList=[NSMutableArray arrayWithCapacity:0];
        }
        [blockSelf.service.listPageCityList removeAllObjects];
        [blockSelf.service.listPageCityList addObjectsFromArray:messageList];
        
        if (blockSelf.service.listPageModel.preDestination.length!=0) {
            
            for (int i=0; i<[messageList count]; i++) {
                UZHomeClass *homeClass = messageList[i];
                if ([homeClass.subClass.NavLinkName isEqualToString:blockSelf.service.listPageModel.preDestination]) {
                    for (int j=0; j<homeClass.navLink.count; j++) {
                        UZHomeSubClass *subClass = homeClass.navLink[j];
                        if ([subClass.NavLinkName isEqualToString:blockSelf.service.listPageModel.destination]) {
                            blockSelf.service.listPageModel.searchKeyword = subClass.MobileSearchKeyWord;
                        }
                    }
                    
                }
                
            }
        }
        
        [blockSelf loadDataIsLoadMore:NO withTableView:tableViewAll];
    } withFailedBlock:^(NSString *code, NSString *msg) {
        [blockSelf hideLoading];
        [blockSelf showLoadFailedWithBlock:^{
            [blockSelf requestCityList];
        }];
    }];
}
-(void)isShowTopBarWithIsAllShow:(BOOL)flag
{
    if (!flag) {
        self.segmentType.hidden=YES;
        self.myScrollView.scrollEnabled=NO;
        __block UZListPageVC *blockSelf =self;
        [UIView animateWithDuration:0.3 animations:^{
            blockSelf.myScrollView.frame=CGRectMake(0, 0, App_Frame_Width, App_Frame_Height-47-HEIGHT(blockSelf.viewWIthFooter));
            blockSelf.myScrollView.contentSize=CGSizeMake(App_Frame_Width, blockSelf.myScrollView.frame.size.height);
            for (UIView *view in blockSelf.myScrollView.subviews) {
                if ([view isMemberOfClass:[UITableView class]]) {
                    CGRect frame=view.frame;
                    frame.size.height=blockSelf.myScrollView.frame.size.height;
                    view.frame=frame;
                }
            }
        }];
        blockSelf.segmentType.selectedIndex = 0;
    }else
    {
        self.segmentType.hidden=NO;
        self.myScrollView.scrollEnabled=YES;
        __block UZListPageVC *blockSelf =self;
        [UIView animateWithDuration:0.3 animations:^{
            blockSelf.myScrollView.frame=CGRectMake(0, 47, App_Frame_Width,App_Frame_Height-44-47-HEIGHT(blockSelf.viewWIthFooter));
            blockSelf.myScrollView.contentSize=CGSizeMake(App_Frame_Width*3, blockSelf.myScrollView.frame.size.height);
            for (UIView *view in blockSelf.myScrollView.subviews) {
                if ([view isMemberOfClass:[UITableView class]]) {
                    CGRect frame=view.frame;
                    frame.size.height=blockSelf.myScrollView.frame.size.height;
                    view.frame=frame;
                }
            }
        }];
        
    }
}
-(NSString *)travelStrWithTraveID:(NSString *)travelID
{
    //线路类型ID（1 为“出境游”，2为“国内游”，3为“周边游”，4为 “当地游”，238为 “邮轮游”，0为搜索
    if ([travelID intValue]==0) {
        return @"搜索";
    }else if([travelID intValue]==1)
    {
        return @"出境游";
    }else if([travelID intValue]==2)
    {
        return @"国内游";
    }
    else if([travelID intValue]==3)
    {
        return @"周边游";
    }
    else if([travelID intValue]==4)
    {
        return @"当地游";
    }else if([travelID intValue]==238)
    {
        return @"邮轮";
    }else if ([travelID intValue]==9896)
    {
        return @"海岛";
    }
    return nil;
}
-(NSString *)travelGAStrCategory
{
    NSString *travelID = _service.listPageModel.travelClassID;
    //线路类型ID（1 为“出境游”，2为“国内游”，3为“周边游”，4为 “当地游”，238为 “邮轮游”，0为搜索
    if ([travelID intValue]==0) {
        return @"list-search";
    }else if([travelID intValue]==1)
    {
        return @"list-outbound";
    }else if([travelID intValue]==2)
    {
        return @"list-domestic";
    }
    else if([travelID intValue]==3)
    {
        return @"list-around";
    }
    else if([travelID intValue]==238)
    {
        return @"list-cruise";
    }else if ([travelID intValue]==9896)
    {
        return @"list-Island";
    }
    return @"list-search";
}
-(NSString *)travelGACutOver
{
    NSString *travelID = _service.listPageModel.travelClassID;
    //线路类型ID（1 为“出境游”，2为“国内游”，3为“周边游”，4为 “当地游”，238为 “邮轮游”，0为搜索
    if ([travelID intValue]==0) {
        return @"";
    }else if([travelID intValue]==1)
    {
        return @"cutoverO";
    }else if([travelID intValue]==2)
    {
        return @"cutoverD";
    }
    else if([travelID intValue]==3)
    {
        return @"cutoverA";
    }
    else if([travelID intValue]==238)
    {
        return @"cutoverC";
    }else if ([travelID intValue]==9896)
    {
        return @"cutoverI";
    }
    return nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
   
    NSLog(@"%@类被释放了", NSStringFromClass([self class]));
    tableViewAll.delegate = nil;
    tableViewBicycleTourism.delegate = nil;
    tableViewGroupTourist.delegate = nil;
}

@end