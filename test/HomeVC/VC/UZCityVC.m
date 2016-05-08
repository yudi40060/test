//
//  UZCityVC.m
//  Uzai
//
//  Created by Uzai on 15/12/1.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZCityVC.h"
#import "UZTableView.h"
#import "UZCityCell.h"
#import "UZSqliteCache.h"
@interface UZCityVC ()<UZTableViewDelegate,UISearchBarDelegate,UITableViewDataSource>
@property (copy, nonatomic) void (^selectCityBlock)();
@property (nonatomic,copy) void (^selectCity)(UZCity *);
@property (copy, nonatomic) void (^cancleBlock)();
@property (nonatomic,strong) UZHomeService *service;
@property (nonatomic,strong) UZTableView *tableView;

@property (nonatomic,strong) NSMutableArray *rightIndexList;
@property (nonatomic,strong) UISearchBar *searchBar;
//所有的数据
@property (nonatomic,strong) NSMutableArray *dataList;
//城市的列表 （key-value）
@property (nonatomic,strong) NSMutableDictionary *cityList;
//搜索的数据
@property (nonatomic,strong) NSMutableArray *searchList;

//热门城市的列表
@property (nonatomic,strong) NSMutableArray *HotCityList;

//历史的列表数据
@property (nonatomic,strong) NSMutableArray *histotyCityList;
//是否含有缓存的数据
@property (nonatomic,assign) BOOL isContainCacheData;
@end

@implementation UZCityVC

#pragma mark  initWith

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cityList=[[NSMutableDictionary alloc]initWithCapacity:0];
        _rightIndexList=[[NSMutableArray alloc]init];
        _searchList=[[NSMutableArray alloc]initWithCapacity:0];
        _histotyCityList=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"城市页面列表页"];
    [self sendViewNameWithName:@"城市页面列表页"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"城市页面列表页"];
}

- (id)initWithSelect:(void(^)(void))selectCityBlock
              cancle:(void(^)(void))cancleBlock
         withService:(UZHomeService *)service
{
    self = [super init];
    if (self) {
        self.selectCityBlock = selectCityBlock;
        self.cancleBlock = cancleBlock;
        _service=service;
    }
    return self;
}
//选择城市的时候
- (id)initWithSelectCity:(void(^)(UZCity *))selectCityBlock
                  cancle:(void(^)(void))cancleBlock
             withService:(UZHomeService *)service
{
    self = [super init];
    if (self) {
        self.selectCity = selectCityBlock;
        self.cancleBlock = cancleBlock;
        _service=service;
    }
    return self;
}
+ (void)showWithController:(UIViewController *)controller
               withService:(UZHomeService *)service
                    select:(void(^)(void))selectCityBlock
                    cancle:(void(^)(void))cancleBlock;

{
    UZCityVC *vc = [[UZCityVC alloc] initWithSelect:selectCityBlock cancle:cancleBlock withService:service];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    naVC.navigationBarHidden = true;
    [controller.navigationController presentViewController:naVC animated:YES completion:nil];
    
}

//选择城市
+ (void)selectCity:(UIViewController *)controller
       withService:(UZHomeService *)service
            select:(void(^)(UZCity *))selectCityBlock
            cancle:(void(^)(void))cancleBlock;
{
    UZCityVC *vc = [[UZCityVC alloc] initWithSelectCity:selectCityBlock cancle:cancleBlock withService:service];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    naVC.navigationBarHidden = true;
    [controller.navigationController presentViewController:naVC animated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    self.searchBar.delegate=self;
    self.searchBar.placeholder=@"输入城市名或首字母进行查询";
    [self.view addSubview:self.searchBar];
    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    if ([ self.searchBar respondsToSelector : @selector (barTintColor)]) {
        float iosVersion=7.1;
        if (version>=iosVersion) {
            //iOS7.1
            [[[[ self.searchBar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0] removeFromSuperview ];
            [ self.searchBar setBackgroundColor :[UIColor ColorRGBWithString:@"f5f5f5"]];
        }
        else
        {
            [self.searchBar setBarTintColor :[UIColor ColorRGBWithString:@"f5f5f5"]];
            [self.searchBar setBackgroundColor :[UIColor ColorRGBWithString:@"f5f5f5"]];
        }
    }
    else
    {
        [[ self.searchBar . subviews objectAtIndex : 0 ] removeFromSuperview ];
        [ self.searchBar  setBackgroundColor :[UIColor ColorRGBWithString:@"f5f5f5"]];
    }
    self.tableView=[[UZTableView alloc]initWithFrame:CGRectMake(0, 44, Main_Screen_Width, self.view.frame.size.height-44-kSelfViewY)];
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    
    [self.tableView.tableView registerNib:[UINib nibWithNibName:@"UZCityCell" bundle:nil] forCellReuseIdentifier:@"UZCityCell"];
    
    self.title=@"选择出发城市";
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
//    [self loadData];
    if ([UZSqliteCache QueryCityList].count)
    {
        //查询城市列表
        _dataList=[UZSqliteCache QueryCityList];
        //查询热门城市的列表
        _HotCityList =[UZSqliteCache QueryHotCityList];
        
        //查询历史的数据
        _histotyCityList=[UZSqliteCache QueryHistoryCityList];
        //获取当前城市首字母
        [self getCurrentFristName:_dataList];
        //获取键值对的列表
        [self getkeyAndValueCityList];
        [self.tableView reloadData];
        self.isContainCacheData=true;
        //数据的加载
        [self loadData];
    }
    else
    {
        self.isContainCacheData=false;
        //数据的加载
        [self loadData];
    }
    
}
-(void)goBack
{
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}
//单机返回的按钮的时候
-(void)CLickNavBack:(UIButton *)button
{
    BLOCK_SAFE(_cancleBlock)();
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(UZTableView *)tableView {
    
    if ([self.searchBar.text length]) {
        return 0;
    }
    return _rightIndexList;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.searchBar.text length]) {
        return 1;
    }
    return _rightIndexList.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.searchBar.text length]) {
        return _searchList.count;
    }
    return [[_cityList objectForKey:[_rightIndexList objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UZCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UZCityCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UZCity *city;
    if ([self.searchBar.text length]) {
        city=[_searchList objectAtIndex:indexPath.row];
        [cell.UZMoreImageView setHidden:NO];
        cell.cityNameLabel.text =city.CityName;
    }
    else
    {
        
        [cell.UZMoreImageView setHidden:YES];
        city=[[_cityList objectForKey:[_rightIndexList objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        if ([UZ_CLIENT.cityName length]&&indexPath.section==0) {
            cell.cityNameLabel.text=[NSString stringWithFormat:@"当前城市:%@", [UZ_CLIENT.cityName stringByReplacingOccurrencesOfString:@"市" withString:@""]];
        }
        else
        {
            cell.cityNameLabel.text =city.CityName;
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![self.searchBar.text length]) {
        if (![[_rightIndexList objectAtIndex:section] isEqualToString:@"当前"]) {
            UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
            [headerView setBackgroundColor:[UIColor ColorRGBWithString:@"f5f5f5"]];
            
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 20)];
            [label setText:[_rightIndexList objectAtIndex:section]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont systemFontOfSize:16.0]];
            [label setTextColor:[UIColor lightGrayColor]];
            [headerView addSubview:label];
            return headerView;
        }
        return nil;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (![self.searchBar.text length]) {
        if (![[_rightIndexList objectAtIndex:section] isEqualToString:@"当前"]) {
            return 20;
        }
        return 0;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&[UZ_CLIENT.cityName length]&&[_searchBar.text length]==0) {
        UZCity *c;
        for (UZCity *city in _dataList) {
            if ([city.CityName isEqualToString:[UZ_CLIENT.cityName stringByReplacingOccurrencesOfString:@"市" withString:@""]]) {
                c=city;
                break;
            }
        }
        //缓存历史的数据
        [UZSqliteCache UpdateIsHittoryState:c];
        if (_selectCity) {
            BLOCK_SAFE(_selectCity)(c);
        }
        else
        {
            UZ_CLIENT.city=c;
            [UZSqliteCache deleteStartCity];//删除出发的城市
            [UZSqliteCache insertStartCity:c];
            BLOCK_SAFE(self.selectCityBlock)();
        }
        if (!_selectCity) {
            //注册通知，刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadCityListData" object:nil];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
        UZCity *city;
        if ([_searchBar.text length]>0) {
            city=[_searchList objectAtIndex:indexPath.row];
            
            city.IsHistory=1;
            //缓存历史的数据
            [UZSqliteCache UpdateIsHittoryState:city];
            if (_selectCity) {
                BLOCK_SAFE(_selectCity)(city);
            }
            else
            {
                UZ_CLIENT.city=city;
                [UZSqliteCache deleteStartCity];//删除出发的城市
                [UZSqliteCache insertStartCity:city];
                BLOCK_SAFE(self.selectCityBlock)();
                
            }
            if (!_selectCity) {
                //刷新目的地城市列表页面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadCityListData" object:nil];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else
        {
            city=[[_cityList objectForKey:[_rightIndexList objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            
            city.IsHistory=1;
            //缓存历史的数据
            [UZSqliteCache UpdateIsHittoryState:city];
            if (_selectCity) {
                BLOCK_SAFE(_selectCity)(city);
            }
            else
            {
                UZ_CLIENT.city=city;
                [UZSqliteCache deleteStartCity];//删除出发的城市
                [UZSqliteCache insertStartCity:city];
                BLOCK_SAFE(self.selectCityBlock)();
            }
            if (!_selectCity) {
                //刷新目的地城市列表页面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadCityListData" object:nil];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}


#pragma mark实现搜索框的协议
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    [_searchList removeAllObjects];
    if (searchText!=nil && searchText.length>0) {
        for (UZCity *city in _dataList) {
            if ([city.CityName rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                [_searchList addObject:city];
            }
            else if ([city.FristName rangeOfString:searchText options:NSCaseInsensitiveSearch].length>0)
            {
                [_searchList addObject:city];
            }
        }
        [_tableView reloadData];
    }
    else
    {
        [_tableView reloadData];
    }
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    [self searchBar:self.searchBar textDidChange:nil];
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //    [self searchBar:self.searchBar textDidChange:nil];
    [_searchBar resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
#pragma mark  数据的加载
-(void)loadData
{
    if (self.isContainCacheData==false) {
         [self showLoadingWithMessage:nil];
    }
    __weak UZCityVC *weakSelf=self;
    [_service cityListWithSuccessBlock:^(NSArray *DataList, NSArray *hotCityList) {
        if (weakSelf.isContainCacheData==false) {
             [weakSelf hideLoading];
        }
        //数据的解析
        weakSelf.dataList=[NSMutableArray arrayWithArray:DataList];
        //获取当前热门城市
        weakSelf.HotCityList=[NSMutableArray arrayWithArray:hotCityList];
        //缓存数据
        [weakSelf CacheDataList];
        //获取当前的首字母
        [weakSelf getCurrentFristName:weakSelf.dataList];
        //获取当前键值的城市列表
        [weakSelf getkeyAndValueCityList];
        //刷新数据库
        [weakSelf.tableView reloadData];
    } withFiledBlock:^(NSString *code, NSString *msg) {
        if (weakSelf.isContainCacheData==false) {
            [weakSelf hideLoading];
        }
    }];

}



#pragma mark private method
-(void)CacheDataList
{
    //数据缓存，如果含有热门的城市修改
    for (UZCity *City in _dataList) {
        @autoreleasepool {
            for (UZCity *hotCity in _HotCityList) {
                if (City.ID ==hotCity.ID) {
                    City.IsHot=[NSString stringWithFormat:@"%@",@"1"];
                }
            }
            [UZSqliteCache insertCityList:City];
        }
    }
}


///获取当前的的首字母
-(void)getCurrentFristName:(NSMutableArray *)dataList
{
    //所有字母的数组
    NSMutableArray *rightListArr=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL flag=NO;
    for (UZCity *city in dataList) {
        @autoreleasepool {
            for (NSString *str in rightListArr) {
                if ([str isEqualToString:city.FristName]) {
                    flag=YES;
                    break;
                }else
                {
                    flag=NO;
                }
            }
            //添加首字母
            if (!flag) {
                [rightListArr addObject:city.FristName];
                flag=NO;
            }
        }
    }
    
    //字母排序
    _rightIndexList = (NSMutableArray *)[rightListArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //添加热门的城市和当前的城市
    if (UZ_CLIENT.cityName) {
        for (UZCity *city in dataList) {
            if ([city.CityName isEqualToString:[UZ_CLIENT.cityName stringByReplacingOccurrencesOfString:@"市" withString:@""]]) {
                
                [_cityList setObject:[NSArray arrayWithObjects:UZ_CLIENT.city, nil] forKey:@"当前"];
                break;
            }
        }
    }
    if ([_histotyCityList count]) {
        [_cityList setObject:_histotyCityList forKey:@"历史选择"];
    }
    if ([_HotCityList count]) {
        [_cityList setObject:_HotCityList forKey:@"热门出发城市"];
    }
}
///获取当前的城市列表
-(void)getCurrentCityList:(NSMutableArray *)dataList
{
    //热门城市所有数据的数组
    _dataList =[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary *dict in dataList) {
        @autoreleasepool {
            UZCity *cityList=[UZCity cityListWithDict:dict];
            [_dataList addObject:cityList];
        }
    }
}
///获取keyValueList的城市列表
-(void)getkeyAndValueCityList
{
    //循环 城市列表，添加对应的字母下
    for (NSString *str in _rightIndexList) {
        @autoreleasepool {
            NSMutableArray *cityArr=[[NSMutableArray alloc]initWithCapacity:0];
            for (UZCity *city in _dataList) {
                if ([city.FristName isEqualToString:str]) {
                    [cityArr addObject:city];
                }
            }
            [_cityList setObject:cityArr forKey:str];
        }
    }
    
    _rightIndexList=[NSMutableArray arrayWithArray:_rightIndexList];
    NSUInteger insertIndex=0;
    if (UZ_CLIENT.cityName) {
        [_rightIndexList insertObject:@"当前" atIndex:0];
        insertIndex=1;
    }
    
    if ([_histotyCityList count]) {
        [_rightIndexList insertObject:@"历史选择" atIndex:insertIndex];
        if (UZ_CLIENT.cityName) {
            insertIndex=2;
        }
        else
        {
            insertIndex=1;
        }
    }
    if ([_HotCityList count]) {
        [_rightIndexList insertObject:@"热门出发城市" atIndex:insertIndex];
    }
}

#pragma mark  --dealloc
-(void)dealloc
{
    
    NSLog(@"%@类被释放了",NSStringFromClass([self class]));
    self.tableView=nil;
    self.rightIndexList=nil;
    self.histotyCityList=nil;
    self.HotCityList=nil;
    self.cityList=nil;
    self.tableView=nil;
    self.searchBar=nil;
    self.dataList=nil;
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
