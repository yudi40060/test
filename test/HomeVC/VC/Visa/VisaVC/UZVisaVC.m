//
//  UZVisaVC.m
//  UZai5.2
//
//  Created by uzai on 14-9-17.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZVisaVC.h"
#import "UZVisCountry.h"
#import "TagList.h"
#import "UZVisCountryList.h"
#import "UIImageView+WebCache.h"
#import "UZVisaCell.h"
#import "UZVisaListVC.h"

@interface UZVisaVC ()<TagListDelegate,UITextFieldDelegate>
{
    NSMutableArray *sectionArr;
}

@property (nonatomic,strong)NSMutableArray *hotArr;
@property (nonatomic,strong)NSMutableArray *countryArr;
@end

@implementation UZVisaVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithService:(UZProductService *)service
{
    self=[super init];
    if (self) {
        _service=service;
    }
    return self;
}
-(void)dealloc
{
    self.hotArr=nil;
    self.countryArr=nil;
    sectionArr=nil;
    self.service=nil;
    self.myTableView=nil;
    self.imageSearch=nil;
    self.txtSearch=nil;
    self.btnSearch=nil;
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
    self.title=@"签证国选择";
    [self sendViewNameWithName:self.GAStr];
    
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"UZVisaCell" bundle:nil] forCellReuseIdentifier:@"UZVisaCell"];
    
    self.txtSearch.delegate=self;

    //给图层添加一个有色边框
    self.imageSearch.layer.borderWidth=1.0f;
    self.imageSearch.layer.borderColor = [[UIColor alloc]initWithWhite:0.85 alpha:0.9].CGColor;
    [self.btnSearch setBackgroundImage:[[UIImage imageNamed:@"button"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
    self.hotArr=[NSMutableArray arrayWithCapacity:0];
    self.countryArr=[NSMutableArray arrayWithCapacity:0];
    [self loadData];
}

-(void)loadData
{
    _myTableView.hidden=YES;
    [self showLoadingWithMessage:nil];
    __weak UZVisaVC *weakSelf=self;
    [_service VisaCountryWithSuccessBlock:^(NSArray *DataList, NSArray *hotVisList) {
        weakSelf.myTableView.hidden=NO;
        [weakSelf hideLoading];
        [weakSelf.hotArr addObjectsFromArray:hotVisList];
        [weakSelf.countryArr addObjectsFromArray:DataList];
        [weakSelf loadTableViewHeader];
        [weakSelf setSectionArr];
        [weakSelf.myTableView reloadData];
    } withFiledBlock:^(NSString *code, NSString *msg) {
        [weakSelf hideLoading];
        [weakSelf showLoadFailedWithBlock:^{
            [weakSelf loadData];
        }];
    }];
}
-(void)setSectionArr
{
    sectionArr = [NSMutableArray arrayWithCapacity:0];
    for (UZVisCountryList *model in self.countryArr) {
        [sectionArr addObject:model.Key];
    }
}
-(void)loadTableViewHeader
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 450)];
    
    UIImageView* iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 4, 13)];
    iconImg.backgroundColor=[UIColor ColorRGBWithString:bgWithTextColor];
    [headerView addSubview:iconImg];
    
    UILabel * starLab =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 270, 24)];
    starLab.backgroundColor = [UIColor clearColor];
    starLab.numberOfLines = 0;
    starLab.text = @"热门签证国";
    starLab.font = [UIFont boldSystemFontOfSize:16];
    starLab.textColor = [UIColor blackColor];
    starLab.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:starLab];
    
    TagList *tagView = [[TagList alloc]initWithFrame:CGRectMake(0, 35, App_Frame_Width, 400) withArr:_hotArr];
    tagView.Delegate = self;
    tagView.backgroundColor = [UIColor clearColor];
    tagView.frame = CGRectMake(0, 30, App_Frame_Width, [tagView getHigh]);
    [headerView addSubview:tagView];
    headerView.frame=CGRectMake(0, 0, App_Frame_Width, [tagView getHigh]+50);
    
    [self.myTableView setTableHeaderView:headerView];
}
-(void)cityClickWithDic:(id)model{
    UZVisaListVC *visaListVC=[[UZVisaListVC alloc]initWithService:_service andVisaCountry:model];
    [self.navigationController pushViewController:visaListVC animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.countryArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UZVisCountryList *countryListModel=self.countryArr[section];
    return countryListModel.countryList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UZVisCountryList *countryListModel=self.countryArr[section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 18)];
    view.backgroundColor = [UIColor colorWithRed:221/225.0 green:221/225.0 blue:221/225.0 alpha:1];
    
    UILabel *starLab =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 270, 18)];
    starLab.backgroundColor = [UIColor clearColor];
    starLab.numberOfLines = 0;
    starLab.text = countryListModel.Key;
    starLab.font = [UIFont boldSystemFontOfSize:16];
    starLab.textColor = [UIColor blackColor];
    starLab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:starLab];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UZVisaCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UZVisaCell" forIndexPath:indexPath];
     UZVisCountryList *countryListModel=self.countryArr[indexPath.section];
    UZVisCountry *countryModel=countryListModel.countryList[indexPath.row];
    [cell.imageFlag setImageWithUrlStr:countryModel.Logo withplaceholder:nil];
    cell.lblName.text=countryModel.CountryName;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UZVisCountryList *countryListModel=self.countryArr[indexPath.section];
    UZVisCountry *countryModel=countryListModel.countryList[indexPath.row];
    
    UZVisaListVC *visaListVC=[[UZVisaListVC alloc]initWithService:_service andVisaCountry:countryModel];
    [self.navigationController pushViewController:visaListVC animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    BOOL tempBool = [self getSearchString:textField.text];
    if(!tempBool)
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@""
                                                            message:@"暂时没有该地区签证"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    return YES;
}

//搜索关键字变化时，自动首字母搜索
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger n = 0;
    NSString* l_string = [string uppercaseString];
    if([sectionArr containsObject:l_string])
        n = [sectionArr indexOfObject:l_string];
    
    [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                       
                                                         inSection:n]
     
                     atScrollPosition:UITableViewScrollPositionTop
     
                             animated:YES];
    return YES;
}

//搜索
-(BOOL)getSearchString:(NSString*)textString
{
    for (int i = 0; i<self.countryArr.count; i++) {
        @autoreleasepool {
            UZVisCountryList *countryListModel=_countryArr[i];
            
            for (int j=0; j<countryListModel.countryList.count;j++) {
                UZVisCountry *model=countryListModel.countryList[j];
                NSString *regEx = [NSString stringWithFormat:@".*%@.*", textString];
                NSRange r = [model.CountryName rangeOfString:regEx options:NSRegularExpressionSearch];
                if ([model.CountryName isEqualToString:textString]) {
                    
                }
                if (r.location != NSNotFound) {
                    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j
                                                              
                                                                                inSection:i]
                     
                                            atScrollPosition:UITableViewScrollPositionTop
                     
                                                    animated:YES];
                    
                    return YES;
                }
                
            }
        }
    }
    return NO;
    
}
- (IBAction)onclickToSearch:(id)sender {
    [self textFieldShouldReturn:self.txtSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
