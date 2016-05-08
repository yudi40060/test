//
//  UZVisaListVC.m
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZVisaListVC.h"
#import "UZVisaCity.h"
#import "UZVisaMessage.h"
#import "UZVisaListCell.h"
#import "UZProductService.h"
#import "UZProdcutWebVC.h"
@interface UZVisaListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *cityNameSelect;
}

@property (nonatomic,strong) NSMutableArray *arrCity;
@property (nonatomic,strong) NSMutableArray *arrData;
@end

@implementation UZVisaListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithService:(UZProductService *)service andVisaCountry:(UZVisCountry *)visaCountryModel
{
    self=[super init];
    if (self) {
        _service=service;
        _visaCountryModel=visaCountryModel;
    }
    return self;
}
-(void)dealloc
{
    self.service=nil;
    self.visaCountryModel=nil;
    cityNameSelect=nil;
    self.arrCity=nil;
    self.arrData=nil;
    self.myTableView=nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=[NSString stringWithFormat:@"%@签证办理",_visaCountryModel.CountryName];
    _arrCity=[NSMutableArray arrayWithCapacity:0];
    _arrData=[NSMutableArray arrayWithCapacity:0];
    
    [_btnCity setTitleColor:[UIColor ColorRGBWithString:bgWithTextColor] forState:UIControlStateNormal];
    _btnCity.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    if ([UZ_CLIENT.city.CityName isEqualToString:@"北京"]) {
        cityNameSelect=@"北京";
    }else
    {
        cityNameSelect=@"上海";
    }
    
    [_btnCity setTitle:[NSString stringWithFormat:@"%@    ",cityNameSelect] forState:UIControlStateNormal];
    [_btnCity setBackgroundImage:[[UIImage imageNamed:@"visa_handle_city_img.png"]stretchableImageWithLeftCapWidth:2 topCapHeight:5] forState:UIControlStateNormal];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"UZVisaListCell" bundle:nil] forCellReuseIdentifier:@"UZVisaListCell"];
    
    [self loadData];
}
-(void)loadData
{
    [self showLoadingWithMessage:nil];
    _myTableView.hidden=YES;
    __weak UZVisaListVC *weakSelf=nil;
    [_service GetVisaAreaWithVisaCountryID:_visaCountryModel.VisaCountryID andCityName:cityNameSelect AndSuccessBlock:^(NSArray *DataList, NSArray *cityArr) {
        [weakSelf hideLoading];
        weakSelf.myTableView.hidden=NO;
        [weakSelf.arrData removeAllObjects];
        [weakSelf.arrCity removeAllObjects];
        [weakSelf.arrData addObjectsFromArray:DataList];
        [weakSelf.arrCity addObjectsFromArray:cityArr];
        [weakSelf isWholecountry];
        [weakSelf.myTableView reloadData];
    } withFiledBlock:^(NSString *code, NSString *msg) {
        [weakSelf hideLoading];
        [weakSelf showLoadFailedWithBlock:^{
            [weakSelf loadData];
        }];
    }];
}
-(void)isWholecountry
{
    if (_arrCity.count==1) {
        UZVisaCity *cityModel=_arrCity[0];
        if ([cityModel.Name isEqualToString:@"全国"]) {
            [self.btnCity setTitle:[NSString stringWithFormat:@"%@    ",cityModel.Name] forState:UIControlStateNormal];
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _arrData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UZVisaListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UZVisaListCell" forIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    UZVisaMessage *model=self.arrData[indexPath.row];
    cell.imageType.image = [UIImage imageNamed:[NSString stringWithFormat:@"visa_icon_%@.png",model.Type]];
    cell.lblName.text=model.Name;
    cell.lblPrice.text=[NSString stringWithFormat:@"￥%@%@",model.VisaPrice,model.IsContainVisa];
    cell.lblVisaArea.text=model.VisaArea;
    cell.lblWorkTime.text=model.WorkTime;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UZVisaMessage *model=self.arrData[indexPath.row];
    UZProductService *service=[[UZProductService alloc]init];
    service.infoStr=model.Url;
    UZProdcutWebVC *webVC=[[UZProdcutWebVC alloc]initWithProductService:service];
    webVC.title=model.Name;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)onclickChangeCity:(id)sender {
    
    if ([_arrCity count]<=0)
    {
        alertMessage(@"暂无该地区签证业务");
        return;
    }
    else if([_arrCity count] == 1)
    {
        UZVisaCity *cityModel=_arrCity[0];
        if ([cityModel.Name isEqualToString:@"全国"]) {
             alertMessage(@"以下领区支持办理全国所有因私护照");
        }

        return;
    }
    [self sendEventWithLable:@"" andScreenName:@"签证" andCategory:@"visa-ListC" andAction:@"sProvince"];
    UZPhotoActionSheet *actionsheet=[[UZPhotoActionSheet alloc]initIndexBlock:^(NSUInteger index) {
        if (index<[_arrCity count]) {
            UZVisaCity *cityModel=_arrCity[index];
            [self.btnCity setTitle:[NSString stringWithFormat:@"%@    ",cityModel.Name] forState:UIControlStateNormal];
            cityNameSelect=cityModel.Name;
            [self loadData];
        }
    }];
    NSMutableArray *dataList=[[NSMutableArray alloc]init];
    for (UZVisaCity *cityModel in _arrCity) {
        [dataList addObject:cityModel.Name];
    }
    [actionsheet showWithDataList:dataList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
