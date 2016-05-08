//
//  UZAllDestinationVC.m
//  Uzai
//
//  Created by Uzai-macMini on 15/12/11.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZAllDestinationVC.h"
#import "UZDestinationCollectionCell.h"
#define AllDestinationCellIdentifier @"DestinationCell"
@interface UZAllDestinationVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
}
@property (nonatomic, strong) UZHomeService *service;
@property (nonatomic, strong)NSMutableArray *allDestinationArr;
@property (nonatomic, strong)UICollectionView *allDestinationCollectionView;

@end

@implementation UZAllDestinationVC
-(id)initWithService:(UZHomeService *)service
{
    self=[super init];
    if (self) {
        _service=service;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self sendViewNameWithName:self.GAStr];
    [self initUI];
    [self getNetWorkData];
}
-(void)getNetWorkData
{
    //本地判断，邮轮NavLinkType为5，全部目的地页面国内为2，其余为1
    NSInteger navLinkType;
    if ([_allHomeClass.subClass.Fields3 isEqualToString:@"238"]) {
        //邮轮设为5
        navLinkType = 5;
    }else if ([_allHomeClass.subClass.Fields3 isEqualToString:@"2"])
    {
        //国内并且在全部目的地页设为2
        navLinkType = 2;
    }else
    {
        //其余为1
        navLinkType = 1;
    }
    //全部目的地页面，HotNavEnable传值为0
    //此处暂时时间传空，[userDefaults objectForKey:@"destinationChannelTime"]!=NULL?[userDefaults objectForKey:@"destinationChannelTime"]:@""
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"更新时间:%@",[userDefaults objectForKey:@"destinationChannelTime"]);
    __weak UZAllDestinationVC *weakSelf = self;
    
    if (_allDestinationArr.count == 0) {
        [self showLoadingWithMessage:nil];
    }
    
    [self.service destinationChannelDataWithNavLinkType:navLinkType withNavLinkID:[_allHomeClass.subClass.ID integerValue] withHotNavEnable:0 withSaveData:@"" withSuccessBlock:^(NSArray *destinationList, NSString *lastTime) {
        [weakSelf hideLoading];
        _allDestinationArr = [weakSelf networkDataToNeedDataArray:destinationList];
        [_allDestinationCollectionView reloadData];
        
        if (_allDestinationArr.count == 0) {
            [self showNoMessage];
        }
        
    } withFailedBlock:^(NSString *code, NSString *msg) {
        [weakSelf hideLoading];
    }];
}

/**
 *  筛选目的地
 *
 *  @param arr 服务器获取的数据
 *
 *  @return 移除“全部”之后的数据
 */
-(NSMutableArray *)networkDataToNeedDataArray:(NSArray *)arr
{
    UZHomeClass *homeClass = arr[0];
    NSMutableArray *needArray = [NSMutableArray array];
    for (UZHomeSubClass *homeSubClass in homeClass.navLink) {
        if (![homeSubClass.NavLinkName isEqualToString:@"全部"]) {
         //剔除“全部”
            [needArray addObject:homeSubClass];
        }
    }
    return needArray;
}
-(void)initUI
{
    //下方collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _allDestinationCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(12*KDestinationScale750, 12*KDestinationScale750, SCREEN_WIDTH-24*KDestinationScale750, SCREEN_HEIGHT-12*KDestinationScale750-(isIOS7Above?64:44)) collectionViewLayout:flowLayout];
    _allDestinationCollectionView.delegate = self;
    _allDestinationCollectionView.dataSource = self;
    _allDestinationCollectionView.showsVerticalScrollIndicator = NO;
    _allDestinationCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_allDestinationCollectionView];
    
    
    [_allDestinationCollectionView registerClass:[UZDestinationCollectionCell class] forCellWithReuseIdentifier:AllDestinationCellIdentifier];
}
#pragma mark -
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_allDestinationArr.count > 0) {
        return _allDestinationArr.count;
    }
    return 0;

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UZHomeSubClass *homeSubClass = _allDestinationArr[indexPath.row];
    UZDestinationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AllDestinationCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UZDestinationCollectionCell alloc]init];
    }
    [cell setDataSource:homeSubClass withImgUrl:[homeSubClass.NavPicUrl getZoomImageURLWithWidth:108*KDestinationScale750]];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(108*KDestinationScale750, KDestinationScale750*81+32);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UZHomeSubClass *homeSubClass = _allDestinationArr[indexPath.row];
    UZListPageService *listPageService = [[UZListPageService alloc]init];
    UZListPageVC *listPageVC = [[UZListPageVC alloc]initWithService:listPageService];
    listPageVC.GAStr = self.GAStr;
    UZListPgeModel *listPageModel = [[UZListPgeModel alloc]init];
    listPageService.listPageModel = listPageModel;
    //1、传到列表页搜索产品必要字段---父导航(国内为本身，非国内为父导航：比如浙江为浙江，法国为欧洲)
    NSString *parentStr = @"";
    NSString *destinationStr = @"";
    if ([_travelClassIDStr isEqualToString:@"2"]) {
        //国内
        parentStr = homeSubClass.NavLinkName;
        destinationStr = @"全部";
        listPageModel.preDestinationID = homeSubClass.ID;
        
    }else
    {
        //非国内
        parentStr = _parentName;
        destinationStr = homeSubClass.NavLinkName;
        listPageModel.preDestinationID = homeSubClass.ParentNavLinkID;
    }
    listPageModel.preDestination = parentStr;
    //2、传到列表页搜索产品必要字段---目的地
    listPageModel.destination = destinationStr;
    listPageModel.searchKeyword = homeSubClass.MobileSearchKeyWord;
    //3、传到列表页搜索产品必要字段---线路类型ID
    listPageModel.travelClassID =_travelClassIDStr;
    //
    [self.navigationController pushViewController:listPageVC animated:YES];
}
-(void)dealloc
{
    self.service = nil;
    self.allHomeClass = nil;
    self.allDestinationArr = nil;
    self.allDestinationCollectionView = nil;
    self.parentName = nil;
    self.travelClassIDStr = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
