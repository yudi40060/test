//
//  UZHomeVC.m
//  Uzai
//
//  Created by Uzai on 15/12/1.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeVC.h"
#import "UZHomeHeadView.h"
#import "UIImage+Conversion.h"
#import "UZCityVC.h"
#import "UZHomeService.h"
#import "UZHomeClassCell.h"
#import "UZHomeCategoryCell.h"
#import "UZHomeSaleCell.h"
#import "UZHomeThemeCell.h"
#import "UZHomeProductCell.h"
#import "UZHomeProductHeaderCell.h"
#import "UZHomeWhereGoCell.h"
#import "UZHomeSayGoCell.h"
#import "UZHomeCustomCell.h"
#import "UZCustomVC.h"
#import "UZDestinationChannelVC.h"
#import "UZAllDestinationVC.h"
#import "UZActivity.h"
#import "UZPhotoActionSheet.h"
#import "UZHomeClass.h"
#import "UZActivity.h"
#import "UZVisaVC.h"
#import "UZRushBuyInfo.h"
#import "UZHomeScaningVC.h"
#import "UZHomeMenuClass.h"
#import "UZProdcutWebVC.h"
#import "LoadingView.h"
#import "UZScaningWebVC.h"
#define currentScaleWidth  375
#define YRWeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define YRStrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
@interface UZHomeVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *navHeaderView;
@property (nonatomic,strong) UZHomeService *service;

@property (nonatomic,strong) NSMutableArray *imageList;
@property (nonatomic,strong) UZBaseCycleScrollView *baseCycleScrollView;

@property (nonatomic,strong) NSMutableArray *topList;
@property (nonatomic,strong) NSMutableArray *subjectList;
@property (nonatomic,strong) UZHomeSubClass *subClass;
@property (nonatomic,strong) NSMutableArray *homeClassList;
@property (nonatomic,strong) NSMutableArray *menuList;//菜单的集合
@property (nonatomic,strong) NSArray *productList;

@property (nonatomic,strong) NSCache *cache;
@property (nonatomic,assign) BOOL isLoadSuccess;//是否加载成功
@property (nonatomic,assign) BOOL isLoading;//是否正在加载
@property (nonatomic,strong) NSString *GAStr;//GA
//特卖会的倒计时
@property (nonatomic,strong) UZRushBuyInfo *info;
//计算加载失败的次数
@property (nonatomic,assign) NSUInteger loadFailIndex;

@end

@implementation UZHomeVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //关闭右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    for (int i=0; i<self.view.subviews.count; i++) {
        @autoreleasepool {
            UIView *view = self.view.subviews[i];
            if ([view isMemberOfClass:[LoadingView class]]) {
                LoadingView *loadingView = (LoadingView *)view;
                if (loadingView.bgImageView.layer.animationKeys.count==0) {
                    [loadingView startAnimation];
                }
                break;
            }
        }
    }
    [self sendViewNameWithName:self.GAStr];
}
- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef __IPHONE_7_0
    if (isIOS7Above) {
        //这个属性属于UIExtendedEdge类型，它可以单独指定矩形的四条边，也可以单独指定、指定全部、全部不指定。
        //指定视图的哪条边需要扩展，不用理会操作栏的透明度。这个属性的默认值是UIRectEdgeAll。
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //如果你使用了不透明的操作栏，设置edgesForExtendedLayout的时候也请将 extendedLayoutIncludesOpaqueBars的值设置为No（默认值是YES）
        self.extendedLayoutIncludesOpaqueBars = NO;
        //如果你不想让scroll view的内容自动调整，将这个属性设为NO（默认值YES）。
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    [self loadSubView];
    _cache=[[NSCache alloc]init];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=true;
    _service=[[UZHomeService alloc]init];
    //接受城市切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataList) name:@"ReloadCityListData" object:nil];
    //接受时间切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataList) name:@"NSSystemClockDidChangeNotification" object:nil];
    
    NSDictionary *dict=[Tool readJsonFileWithName:@"homeTopIndexData"];
    self.productList=[UZProduct productList:[Tool readJsonFileWithName:@"homeProductIndexData"]];
    [self reloadData:dict];
    [self loadData:dict==nil?false:true];//默认加载数据
    self.GAStr=[NSString stringWithFormat:@"启动页->%@站",UZ_CLIENT.city.CityName];
}
//视图加载页面
-(void)loadSubView
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor=bgF5Color;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerClass:[UZHomeProductCell class] forCellReuseIdentifier:@"homeProductCell"];
    [self.tableView registerClass:[UZHomeWhereGoCell class] forCellReuseIdentifier:@"homeWhereGoCell"];
    [self.tableView registerClass:[UZHomeClassCell class] forCellReuseIdentifier:@"homeClassCell"];
    [self.tableView registerClass:[UZHomeSaleCell class] forCellReuseIdentifier:@"homeSaleCell"];
    [self.tableView registerClass:[UZHomeThemeCell class] forCellReuseIdentifier:@"homeThemeCell"];
    [self.tableView registerClass:[UZHomeCategoryCell class] forCellReuseIdentifier:@"homeCategoryCell"];
    
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    footView.backgroundColor=[UIColor clearColor];
    self.tableView.tableFooterView=footView;
    
    _navHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, App_Frame_Width, 84)];
    [self.view addSubview:_navHeaderView];
    self.headerView = [[NSBundle mainBundle]loadNibNamed:@"UZHomeHeadView" owner:nil options:nil][0];
    @YRWeakObj(self);
    self.headerView.SelectIndexBlock=^(NSUInteger selectIndex){
        @YRStrongObj(self);
        [self topNavtionTouch:selectIndex];
    };
    self.headerView.frame=CGRectMake(0, 20, App_Frame_Width, 64);
    [_navHeaderView addSubview:self.headerView];
    [self.headerView setCityNameWithStr:UZ_CLIENT.city.CityName];
    
    //添加首页的banner图片视图
    _imageList=[[NSMutableArray alloc]init];
    
    //添加浮层View
    [self initWithRefreshView];
    
}

#pragma mark Touch Event
-(void)topNavtionTouch:(NSUInteger)selectIndex
{
    if (selectIndex == 100) {
        //进入城市选择页面
        [UZCityVC showWithController:self withService:self.service select:^{
            [self reloadDataList];
        } cancle:nil];
    }
    else if (selectIndex == 101) {
        [self goSearchVC];
    }
    else if (selectIndex == 102)
    {
        [self call];
    }else if (selectIndex==105)
    {
        [self goScaningVC];
    }
}

-(void)call
{
    [self sendEventWithLable:@"call" andScreenName:@"首页" andCategory:@"home" andAction:@"call"];
     __weak UZHomeVC *weakSelf=self;
    UZPhotoActionSheet *actionsheet=[[UZPhotoActionSheet alloc]initIndexBlock:^(NSUInteger index) {
        if (index==0) {
            if([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location == NSNotFound) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"客服电话为: 400-000-8888"
                                                                message:@"本设备不支持电话功能"
                                                               delegate:nil
                                                      cancelButtonTitle:@"我知道了"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            [weakSelf sendEventWithLable:@"拨打" andScreenName:@"首页" andCategory:@"home" andAction:@"call"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000008888"]];
        }else
        {
            [weakSelf sendEventWithLable:@"cancel" andScreenName:@"首页" andCategory:@"home" andAction:@"call"];
        }
    }];
    NSArray *dataList=@[@"拨打电话（400-000-8888）"];
    [actionsheet showWithDataList:dataList];
}
//跳转搜索页面
-(void)goSearchVC
{
    __weak UZHomeVC *weakSelf=self;
    [UZSearch_New2VC showWithController:self sussecc:^(NSString * __nonnull searchText) {
        UZListPageService *service=[[UZListPageService alloc]init];
        UZListPageVC *listPageVC=[[UZListPageVC alloc]initWithService:service];
        listPageVC.GAStr=[NSString stringWithFormat:@"%@->搜索页",weakSelf.GAStr];
        UZListPgeModel *listPageModel=[[UZListPgeModel alloc]init];
        listPageModel.destination=searchText;
        service.listPageModel=listPageModel;
        listPageModel.isSearch=YES;
        if ([searchText integerValue]) {
            listPageModel.isProductSearch=YES;
        }
        listPageModel.city=UZ_CLIENT.startCity;
        listPageModel.travelClassID=@"0";
        listPageVC.hidesBottomBarWhenPushed=YES;
        [weakSelf.navigationController setNavigationBarHidden:false animated:false];
        [weakSelf.navigationController pushViewController:listPageVC animated:YES];
    } fail:^{
        
    }];
}
//跳转二维码扫描界面
-(void)goScaningVC
{
    __weak UZHomeVC *weakSelf=self;
    [self sendEventWithLable:@"scanCode" andScreenName:@"home" andCategory:@"home" andAction:@"scanCode"];
    [UZHomeScaningVC showWithController:self select:^(NSString *urlStr) {
         if ([urlStr.lowercaseString rangeOfString:@"uzai.com"].location!=NSNotFound&&[urlStr.lowercaseString rangeOfString:@"/trip/wap/"].location!=NSNotFound)
        {
            NSString *subTempProductId=[urlStr substringFromIndex:[urlStr.lowercaseString rangeOfString:@"/trip/wap/"].length+[urlStr.lowercaseString rangeOfString:@"/trip/wap/"].location];
            NSRange range1=[subTempProductId rangeOfString:@".htm"];
            NSString *productId=[subTempProductId substringToIndex:range1.location];
            UZProductService *service=[[UZProductService alloc]init];
            service.productId=productId;
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"UZProductInfoVC" bundle:[NSBundle mainBundle]];
            UZProductInfoVC *productDetailVC=[storyBoard instantiateViewControllerWithIdentifier:@"ProductInfoVC"];
            service.uzaiProductClassId=@"自助游";
            productDetailVC.GAStr=[weakSelf setGaStr:weakSelf.GAStr withNextGaStr:@"自由行产品页"];
            productDetailVC.service=service;
            productDetailVC.hidesBottomBarWhenPushed=true;
            [weakSelf.navigationController pushViewController:productDetailVC animated:YES];
            return ;
        }
        if([urlStr rangeOfString:@"uzai.com"].location!=NSNotFound&&[urlStr rangeOfString:@"/waptour-"].location!=NSNotFound)
        {
            NSString *subTempProductId=[urlStr substringFromIndex:[urlStr.lowercaseString rangeOfString:@"/waptour-"].length+[urlStr.lowercaseString rangeOfString:@"/waptour-"].location];
            NSRange range1=[subTempProductId.lowercaseString rangeOfString:@".htm"];
            NSString *productId=[subTempProductId substringToIndex:range1.location];
            UZProductService *service=[[UZProductService alloc]init];
            service.productId=productId;
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"UZProductInfoVC" bundle:[NSBundle mainBundle]];
            UZProductInfoVC *productDetailVC=[storyBoard instantiateViewControllerWithIdentifier:@"ProductInfoVC"];
            service.uzaiProductClassId=@"跟团游";
            productDetailVC.GAStr=[weakSelf setGaStr:weakSelf.GAStr withNextGaStr:@"跟团产品页"];
            productDetailVC.service=service;
            productDetailVC.hidesBottomBarWhenPushed=true;
            [weakSelf.navigationController pushViewController:productDetailVC animated:YES];
            return ;
        }
        if([urlStr.lowercaseString rangeOfString:@"uzai.com"].location!=NSNotFound)
        {
            UZScaningWebVC *vc=[[UZScaningWebVC alloc]init];
            vc.hidesBottomBarWhenPushed=true;
            NSString *EventName=[NSString stringWithFormat:@"%@->二维码扫描",weakSelf.GAStr];
            vc.GAStr=EventName;
            vc.infoStr=urlStr;
            [self.navigationController pushViewController:vc animated:true];
            return;
        }
        if ([self validateUrl:urlStr]) {
            UZScaningWebVC *vc=[[UZScaningWebVC alloc]init];
            vc.hidesBottomBarWhenPushed=true;
            NSString *EventName=[NSString stringWithFormat:@"%@->二维码扫描",weakSelf.GAStr];
            vc.GAStr=EventName;
            vc.infoStr=urlStr;
            [self.navigationController pushViewController:vc animated:true];
            return;
        }
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }];
}

- (BOOL)validateUrl:(NSString *) textString
{
    if (([textString hasPrefix:@"https://"]||[textString hasPrefix:@"http://"])&&[textString rangeOfString:@"qianduan"].location!=NSNotFound) {
        return YES;
    }
    return false;
}
//下拉刷新
-(void)initWithRefreshView
{
    __weak UZHomeVC *weakSelf=self;
    UZAnimationRefreshHeader *header = [UZAnimationRefreshHeader headerWithRefreshingBlock:^{
         weakSelf.cache=[[NSCache alloc]init];
        //表示正在加载中....
        [weakSelf loadData:true];//加载数据
    }];
    _tableView.header = header;
}


#pragma mark reloadData
-(void)reloadDataList
{
    [self.headerView setCityNameWithStr:UZ_CLIENT.city.CityName];
    [self loadData:true];
    self.GAStr=[NSString stringWithFormat:@"启动页->%@站",UZ_CLIENT.city.CityName];
    self.isLoadSuccess=false;
    _cache=[[NSCache alloc]init];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isLoadSuccess==false) {
        return 0;
    }
    return 7;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==6) {
        return (self.productList.count>12?12:self.productList.count)+1;
    }else if (section==4)
    {
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSString *key=[NSString stringWithFormat:@"Cell"];
        UITableViewCell *cell=[_cache objectForKey:key];
        if (cell) {
            return cell;
        }
        //广告
        cell=[tableView dequeueReusableCellWithIdentifier:key];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UZBaseCycleScrollView class]]) {
                [obj removeFromSuperview];
            }
        }];
        [cell addSubview:_baseCycleScrollView];
        [_cache setObject:cell forKey:key];
        return cell;
    }else if(indexPath.section==1)
    {
        //分类
        NSString *key=[NSString stringWithFormat:@"homeClassCell"];
        UZHomeClassCell *cell=[_cache objectForKey:key];
        if (cell) {
            return cell;
        }
        cell=[tableView dequeueReusableCellWithIdentifier:@"homeClassCell"];
        if (cell==nil) {
            cell=[[UZHomeClassCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeClassCell"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        __weak UZHomeVC *weakSelf=self;
        [cell datasourceWithData:self.homeClassList withclassBlock:^(NSUInteger index) {
            [weakSelf pushListVC:index];
        }];
        [_cache setObject:cell forKey:key];
        return cell;
    }else if (indexPath.section==2)
    {
        //类别
        NSString *key=[NSString stringWithFormat:@"homeCategoryCell"];
        UZHomeCategoryCell *cell=[_cache objectForKey:key];
        if (cell) {
            return cell;
        }
        cell=[tableView dequeueReusableCellWithIdentifier:key];
        @weakify(self);
        [cell dataSource:self.menuList cateGoryBlock:^(NSUInteger index) {
            @strongify(self);
            [self pushCatrgoryIndex:index];
        }];
        if ([self.menuList count]==0) {
            cell.hidden=true;
        }else
        {
            cell.hidden=false;
        }
        [_cache setObject:cell forKey:key];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==3)
    {
        //特卖会
        NSString *key=[NSString stringWithFormat:@"homeSaleCell"];
        UZHomeSaleCell *cell=[_cache objectForKey:key];
        if (cell) {
            return cell;
        }
        cell=[tableView dequeueReusableCellWithIdentifier:key];
        if ([self.info.tmhType integerValue]==0) {
            cell.hidden=true;
        }else
        {
             cell.hidden=false;
        }
        [cell datasource:self.info withSaleIndexBlock:^(NSUInteger index) {
            [UZSpecialVC selectProductType:index];
        }];
         [_cache setObject:cell forKey:key];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==4)
    {
        if (indexPath.row==0) {
            //说走就走
            UZHomeSayGoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"homeSayGoCell"];
            if (cell==nil) {
                cell=[[UZHomeSayGoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeSayGoCell"];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        NSString *key=[NSString stringWithFormat:@"homeThemeCell"];
        //主题
        UZHomeThemeCell *cell=[_cache objectForKey:key];
        if (cell) {
            return cell;
        }
        cell=[tableView dequeueReusableCellWithIdentifier:key];
        [_cache setObject:cell forKey:key];
        __weak UZHomeVC *weakSelf=self;
        [cell dataSource:self.subjectList withthemeIndexBlock:^(NSUInteger index) {
            UZActivity *activty=[weakSelf.subjectList objectAtIndex:index];
            [UZHomeVC pushActiveVC:activty withEventName:[NSString stringWithFormat:@"%@->主题游_%@",weakSelf.GAStr,activty.topicsName] andCurrentVC:weakSelf];
        }];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==5) {
        //当季去哪儿玩,跳转到当季推荐频道页
        NSString *key=[NSString stringWithFormat:@"homeWhereGoCell"];
        UZHomeWhereGoCell *cell=[_cache objectForKey:key];
        if (cell) {
            return cell;
        }
        cell=[tableView dequeueReusableCellWithIdentifier:@"homeWhereGoCell"];
        [cell datasource:self.subClass];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [_cache setObject:cell forKey:key];
        return cell;
    }
    else if(indexPath.section==6)
    {
        if (indexPath.row==0) {
            NSString *key=[NSString stringWithFormat:@"homeProductHeaderCell%ld-%ld",(long)indexPath.row,(long)indexPath.section];
            UZHomeProductHeaderCell *cell=[_cache objectForKey:key];
            if (cell) {
                return cell;
            }
            cell=[tableView dequeueReusableCellWithIdentifier:@"homeProductHeaderCell"];
            if (cell==nil) {
                cell=[[UZHomeProductHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeProductHeaderCell"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.hidden=self.productList.count==0?true:false;
            [_cache setObject:cell forKey:key];
            return cell;
        }
        //产品
        NSString *key=[NSString stringWithFormat:@"homeProductCell%ld-%ld",(long)indexPath.row,(long)indexPath.section];
        UZHomeProductCell *cell=[_cache objectForKey:key];
        if (cell) {
            return cell;
        }
        cell=[tableView dequeueReusableCellWithIdentifier:@"homeProductCell"];
        [cell dataSource:self.productList[indexPath.row-1]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        //已经废弃  （之前是定制游）
        UZHomeCustomCell *cell=[tableView dequeueReusableCellWithIdentifier:@"homeCustomCell"];
        if (cell==nil) {
            cell=[[UZHomeCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeCustomCell"];
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return HEIGHT(self.baseCycleScrollView);
    }else if (indexPath.section==1)
    {
        //只能显示两排
        NSUInteger number=self.homeClassList.count%5==0?self.homeClassList.count/5:1+self.homeClassList.count/5;
        return 92*Main_Screen_Width/currentScaleWidth*(number>2?2:number);
    }
    else if (indexPath.section==2)
    {
        if (self.menuList.count==0) {
            return 0;
        }
        return 74*Main_Screen_Width/currentScaleWidth+10;
    }
    else if(indexPath.section==3)
    {
        if ([self.info.tmhType integerValue]==0) {
            return 0;
        }else if ([self.info.tmhType integerValue]==1||[self.info.tmhType integerValue]==2||[self.info.tmhType integerValue]==3)
        {
             return Main_Screen_Width*165/currentScaleWidth+47*Main_Screen_Width/currentScaleWidth+10;
        }else
        {
            return Main_Screen_Width*96/currentScaleWidth+47*Main_Screen_Width/currentScaleWidth+10;
        }
    }else if (indexPath.section==4)
    {
        if (indexPath.row==0) {
            return 59*Main_Screen_Width/currentScaleWidth;
        }
        if (self.subjectList.count<2) {
            return 0;
        }else
        {
            NSUInteger count=self.subjectList.count/2;
            return (count * 76)*Main_Screen_Width/currentScaleWidth+47*Main_Screen_Width/currentScaleWidth+5;
        }
    }else if (indexPath.section==5)
    {
        if (self.subjectList.count==0) {
            return 0;
        }
        if (self.subClass.Fields2.length!=0) {//&&self.subClass.Fields3.length!=0
            return 10+142*Main_Screen_Width/currentScaleWidth;
        }
        return 0;
    }
    else if (indexPath.section==6)
    {
        if (indexPath.row==0) {
            if (self.productList.count==0) {
                return 0;
            }
            return 47*Main_Screen_Width/currentScaleWidth;
        }
        return 216*Main_Screen_Width/currentScaleWidth+70;
    }else
    {
        return 93*Main_Screen_Width/currentScaleWidth+10;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==5) {
        //当季去哪儿玩
        if (self.subClass.Fields2.length > 0) {
            //不为空进入到频道页
            UZDestinationChannelVC *destinationChannelVC = [[UZDestinationChannelVC alloc]initWithService:self.service];
            destinationChannelVC.rowCount = 2;
            destinationChannelVC.field2Str = self.subClass.Fields2;
            destinationChannelVC.travelClassIDStr = @"0";
            destinationChannelVC.travelTypeStr = @"当季去哪儿";
            destinationChannelVC.GAStr=[self setGaStr:self.GAStr withNextGaStr:@"当季去哪玩频道页"];
            destinationChannelVC.title = @"当季去哪儿玩";
            destinationChannelVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:destinationChannelVC animated:YES];
        }
    }else if(indexPath.section==6&&indexPath.row>0)
    {
        UZProductService *service=[[UZProductService alloc]init];
        UZProduct *product=[self.productList objectAtIndex:indexPath.row-1];
        service.productId=product.ProductId;
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"UZProductInfoVC" bundle:[NSBundle mainBundle]];
        UZProductInfoVC *productDetailVC=[storyBoard instantiateViewControllerWithIdentifier:@"ProductInfoVC"];
        if ([product.UzaiTravelClassID isEqualToString:@"跟团游"]){
            service.uzaiProductClassId=@"跟团游";
            productDetailVC.GAStr=[self setGaStr:self.GAStr withNextGaStr:@"跟团产品页"];
        }
        else{
            service.uzaiProductClassId=@"自由行";
            productDetailVC.GAStr=[self setGaStr:self.GAStr withNextGaStr:@"自由行产品页"];
        }
        productDetailVC.service=service;
        productDetailVC.hidesBottomBarWhenPushed=true;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
}

#pragma mark  页面之间的跳转
//类别跳转
-(void)pushCatrgoryIndex:(NSUInteger)index
{
    UZHomeMenuClass *class=[self.menuList objectAtIndex:index];
    if ([class.menuIndexType integerValue] ==1) {
        UZProductService *service=[[UZProductService alloc]init];
        //签证
        UZVisaVC *visaVC=[[UZVisaVC alloc]initWithService:service];
        visaVC.hidesBottomBarWhenPushed=YES;
        visaVC.GAStr= [self setGaStr:self.GAStr withNextGaStr:@"签证列表页"];
        [self.navigationController pushViewController:visaVC animated:YES];
    }else if([class.menuIndexType integerValue] ==2)
    {
        UZProductService *service=[[UZProductService alloc]init];
        service.infoStr=class.skipURL;
        UZHomeActivityVC *vc=[[UZHomeActivityVC alloc]initWithProductService:service];
        vc.GAStr= [self setGaStr:self.GAStr withNextGaStr:@"booking.com"];
        vc.shareContent=class.skipDes;
        vc.hidesBottomBarWhenPushed=true;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([class.menuIndexType integerValue] ==3)
    {
        UZCustomVC *customVC=[[UZCustomVC alloc]initWithService:_service];
        customVC.hidesBottomBarWhenPushed=true;
       customVC.GAStr = [self setGaStr:self.GAStr withNextGaStr:@"私家团定制页"];
        [self.navigationController pushViewController:customVC animated:true];
    }
}
//类型的跳转
-(void)pushListVC:(NSUInteger )index
{
    UZHomeClass *homeClass=[self.homeClassList objectAtIndex:index];
    //逻辑:1、首先判断是不是邮轮，是邮轮则进入到列表页
    //2、不是邮轮的:判断field2是不是为空，为空进入到全部目的地页面，不为空则进入到频道页
    if ([homeClass.subClass.MobileSearchKeyWord isEqualToString:@"邮轮"] || [homeClass.subClass.Fields3 isEqualToString:@"238"]) {//邮轮
        //此处进入到列表页
        UZListPageService *listPageService = [[UZListPageService alloc]init];
        UZListPageVC *listPageVC = [[UZListPageVC alloc]initWithService:listPageService];
        listPageVC.GAStr = [self setGaStr:self.GAStr withNextGaStr:@"邮轮列表页"];
        UZListPgeModel *listPageModel = [[UZListPgeModel alloc]init];
        listPageService.listPageModel = listPageModel;
//        listPageModel.travelClassID = homeClass.subClass.Fields3;
        listPageModel.travelClassID = @"238";
        
        listPageVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:listPageVC animated:YES];
        
    }else
    {
        //判断field2是否为空
        if ([homeClass.subClass.Fields2 isEqualToString:@""]) {
            //为空进入到全部目的地
            UZAllDestinationVC *allDestinationVC = [[UZAllDestinationVC alloc]initWithService:self.service];
            allDestinationVC.travelClassIDStr = homeClass.subClass.Fields3;
            allDestinationVC.parentName = homeClass.subClass.NavLinkName;
            allDestinationVC.allHomeClass = homeClass;
            allDestinationVC.title=[self stringWithFormatStr:homeClass.subClass.NavLinkName withAppendStr:@"全部目的地"];
            allDestinationVC.GAStr= [self setGaStr:self.GAStr withNextGaStr:allDestinationVC.title];
            allDestinationVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:allDestinationVC animated:YES];
        }else
        {
            //不为空进入到频道页
            UZDestinationChannelVC *destinationChannelVC = [[UZDestinationChannelVC alloc]initWithService:self.service];
            if ([homeClass.subClass.Fields3 isEqualToString:@"2"]) {
                //国内游
                destinationChannelVC.rowCount = 3;
                destinationChannelVC.travelTypeStr = @"国内游";
            }else
            {
                //境外游
                destinationChannelVC.rowCount = 2;
                destinationChannelVC.travelTypeStr = @"境外游";
            }
            destinationChannelVC.field2Str = homeClass.subClass.Fields2;
            destinationChannelVC.travelClassIDStr = homeClass.subClass.Fields3;
            destinationChannelVC.homeClass = homeClass;
            
            destinationChannelVC.GAStr =[self setGaStr:self.GAStr withNextGaStr:[self stringWithFormatStr:homeClass.subClass.MobileSearchKeyWord withAppendStr:@"频道页"]];
            destinationChannelVC.title = homeClass.subClass.NavLinkName;
            destinationChannelVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:destinationChannelVC animated:YES];
        }
    }
}
//主题游
-(void)pushThemeVC:(NSUInteger)index
{
    UZActivity *activty=[self.subjectList objectAtIndex:index];
    UZProductService *service=[[UZProductService alloc]init];
    service.infoStr=activty.activityUrl;
    UZHomeActivityVC *webVC=[[UZHomeActivityVC alloc]initWithProductService:service];
    webVC.hidesBottomBarWhenPushed=true;
    webVC.isShare=activty.isShare;
    webVC.shareUrl=activty.activityUrl;
    webVC.shareContent=activty.shareContent;
    webVC.GAStr=[NSString stringWithFormat:@"%@->主题游_%@",self.GAStr,activty.topicsName];
    [self.navigationController pushViewController:webVC animated:true];
}
//首页的banner
+(void)pushActiveVC:(UZActivity *)activity withEventName:(NSString *)pageEventName andCurrentVC:(UIViewController *)currentVC
{
    //单机image之后出发的事件
    UZProductService *service=[[UZProductService alloc]init];
    if (([activity.type integerValue]==2||[activity.type integerValue]==1)&&activity.activityUrl!=nil) {
        
        if (activity.activityUrl.length==0) {
            return;
        }
        UZHomeActivityVC *productDetailVC=[[UZHomeActivityVC alloc]initWithProductService:service];
        service.infoStr=[[activity.activityUrl stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        productDetailVC.title=activity.topicsName;
        productDetailVC.GAStr=pageEventName;
        productDetailVC.isShare=activity.isShare;
        productDetailVC.shareUrl=activity.activityUrl;
        productDetailVC.shareContent=activity.shareContent;
        productDetailVC.hidesBottomBarWhenPushed=YES;
        [currentVC.navigationController pushViewController:productDetailVC animated:YES];
    }
    else if ([activity.type integerValue]==3)
    {
        if ([activity.uzaiTravelClassID intValue] == 15 ||
            [activity.uzaiTravelClassID  intValue] == 16 ||
            [activity.uzaiTravelClassID  intValue] == 29 ||
            [activity.uzaiTravelClassID  intValue] == 99) {
            service.uzaiProductClassId=@"自助游";
        }
        else
        {
             service.uzaiProductClassId=@"跟团游";
        }
        service.productId=activity.productID;
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"UZProductInfoVC" bundle:[NSBundle mainBundle]];
        UZProductInfoVC *productDetailVC=[storyBoard instantiateViewControllerWithIdentifier:@"ProductInfoVC"];
        productDetailVC.service=service;
        productDetailVC.GAStr=[NSString stringWithFormat:@"%@->%@产品页",pageEventName,service.uzaiProductClassId];
        productDetailVC.hidesBottomBarWhenPushed=YES;
        [currentVC.navigationController pushViewController:productDetailVC animated:YES];
    }
    else if ([activity.type integerValue]==5)
    {
        UZKeSongFangVC *ksfVC = [[UZKeSongFangVC alloc]init];
        ksfVC.service = [[UZHomeService alloc]init];
        ksfVC.shareURL = activity.activityUrl;
        ksfVC.shareContent = activity.shareContent;
        ksfVC.hidesBottomBarWhenPushed = YES;
        ksfVC.GAStr=pageEventName;
        [currentVC.navigationController pushViewController:ksfVC animated:YES];
    }
    else
    {
        UZListPageService *service=[[UZListPageService alloc]init];
        UZListPageVC *listPageVC=[[UZListPageVC alloc]initWithService:service];
        UZListPgeModel *listPageModel=[[UZListPgeModel alloc]init];
        service.listPageModel=listPageModel;
        service.listPageModel.isSearch=YES;
        service.listPageModel.destination=[NSString stringWithFormat:@"%@",activity.keyword];
        service.listPageModel.travelClassID=activity.uzaiTravelClassID;
        listPageVC.GAStr=pageEventName;
        listPageVC.hidesBottomBarWhenPushed=YES;
        [currentVC.navigationController pushViewController:listPageVC animated:YES];
    }
}

#pragma mark
#pragma mark scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>=100) {
        _navHeaderView.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.alpha=1;
        [_headerView setOffsetState];
        _navHeaderView.frame = CGRectMake(0,-20, WIDTH(_navHeaderView), HEIGHT(_navHeaderView));
        
    }else if (scrollView.contentOffset.y<100 && scrollView.contentOffset.y>0)
    {
        CGFloat alpha = (scrollView.contentOffset.y+50)/150.0;
        _navHeaderView.backgroundColor = [UIColor ColorRGBWithString:@"#ffffff" WithAlpha:alpha];
        [_headerView setOffsetState];
        _navHeaderView.frame = CGRectMake(0, -20, WIDTH(_navHeaderView), HEIGHT(_navHeaderView));
    }
    else if (scrollView.contentOffset.y==0)
    {
        [_headerView setNormalState];
        _navHeaderView.backgroundColor = [UIColor clearColor];
        _navHeaderView.frame = CGRectMake(0,-20, WIDTH(_navHeaderView), HEIGHT(_navHeaderView));
    }
    else
    {
        _navHeaderView.frame = CGRectMake(0, scrollView.contentOffset.y-20, WIDTH(_navHeaderView), HEIGHT(_navHeaderView));
    }
}

#pragma mark  loadData
-(void)loadData:(BOOL)isdragRefresh
{
     __weak UZHomeVC *weakSelf=self;
    //判断是否正在加载，防止重复加载
    if (self.isLoading==false) {
        self.isLoading=true;
        if (isdragRefresh==false) {
            [self showLoadingWithMessage:@""];
        }
        
        if (self.service==nil) {
            self.service=[[UZHomeService alloc]init];
        }
        [self.service IndexWithSuccesBlock:^() {
            [weakSelf hideLoading];
            weakSelf.isLoading=false;
            weakSelf.isLoadSuccess=true;
            NSDictionary *dict=[Tool readJsonFileWithName:@"homeTopIndexData"];
            //主线程刷新
            [UZTheadCommon enqueueMainThreadPool:^{
                [weakSelf reloadData:dict];
            }];
            [weakSelf loadProdct];//加载产品
            //刷新的状态
            if (isdragRefresh) {
                [weakSelf endRefreshWithScrollView:weakSelf.tableView];
            }
        } withFiledBlock:^(NSString *code, NSString *msg) {
            [weakSelf hideLoading];
            if (isdragRefresh) {
                [weakSelf endRefreshWithScrollView:weakSelf.tableView];
            }
            weakSelf.isLoading=false;
            weakSelf.isLoadSuccess=false;
            if (!isdragRefresh) {
                [weakSelf showLoadFailedWithBlock:^{
                    [weakSelf loadData:isdragRefresh];//重新加载
                }];
            }
        }];
        
    }
}
//加载猜你喜欢的产品
-(void)loadProdct
{
    __weak UZHomeVC *weakSelf=self;
    if (self.loadFailIndex==3) {//如果加载失败3次，就不加载了。
        return;
    }
    [self.service indexProductWithUserId:nil SuccessBlock:^(NSArray *productList) {
        weakSelf.productList=[[NSMutableArray alloc]init];
        weakSelf.loadFailIndex=0;
        [UZTheadCommon enqueueMainThreadPool:^{
            weakSelf.productList=[UZProduct productList:[Tool readJsonFileWithName:@"homeProductIndexData"]];
            [weakSelf.tableView reloadData];
        }];
    } withFiledBlock:^(NSString *code, NSString *msg) {
        weakSelf.loadFailIndex++;
        [weakSelf loadProdct];//继续加载
    }];
}
//显示数据
-(void)reloadData:(NSDictionary *)dict
{
    self.cache=[[NSCache alloc]init];
    self.topList=[UZActivity arrayListWithKeyList:[dict objectForKey:@"IndexTopBanner"]];
    self.subjectList=[UZActivity arrayListWithKeyList:[dict objectForKey:@"IndexFeatureTravel"]];
    self.homeClassList=[UZHomeClass getHomeClassList:[dict objectForKey:@"IndexNavLink"]];
    NSArray *whereToGoList=[NSArray arrayWithObject:[UZHomeSubClass homeSubClassWithDict:[dict objectForKey:@"IndexWhereToGONavLink"]]];
    self.menuList=[UZHomeMenuClass getMenuList:[dict objectForKey:@"ServiceModel"]];
    self.info=[UZRushBuyInfo getRushBuyInfo:[dict objectForKey:@"TmhInlet"]];
    self.imageList=[[NSMutableArray alloc]init];
    for (UZActivity *activity in self.topList) {
        [self.imageList addObject:activity.imgUrl];
    }
    
    //是否显示tab特卖会
    [[Tool getAppDelegate].appDelegateService isTabShowSpecial:[self.info.tmhType integerValue]==0 ? NO : YES ];
    [UZPersonCenterVC isShowBadge];
    
    //顶部的banner
    __block UZBaseCycleScrollView *tempBaseCycleScrollView = [[UZBaseCycleScrollView alloc]initWithFrame:CGRectMake(0, 0,WIDTH(self.view), 170*Main_Screen_Width/currentScaleWidth) images:_imageList blockFunc:^(NSInteger imageIndex) {
        //_PhoneAlbumTopList
        UZActivity *activity=[self.topList objectAtIndex:imageIndex];
        if (imageIndex==0) {
            activity.activityUrl=@"http://m.uzai.com:7999/subject/haiduancuofeng";
        }else if (imageIndex==1)
        {
            activity.activityUrl=@"http://m.uzai.com:7999/subject/pufa";
        }
        NSString *EventName=[NSString stringWithFormat:@"%@->Banner_%@",self.GAStr,activity.name];
        [UZHomeVC pushActiveVC:activity withEventName:EventName andCurrentVC:self];
    }];
    tempBaseCycleScrollView.images=[NSArray arrayWithArray:self.imageList];
    self.baseCycleScrollView=tempBaseCycleScrollView;
    [self.baseCycleScrollView reloadData];//刷新数据
    
    if (whereToGoList.count>0) {
        self.subClass=whereToGoList[0];
    }
    self.isLoadSuccess=true;
    [self.tableView reloadData];//刷新数据
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:false];
}



/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
