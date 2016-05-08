//
//  UZCustomVC.m
//  UZai5.2
//啊啊阿飞啊水电费啊水电费啊水电费啊水
//  Created by UZAI on 14-9-21.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZCustomVC.h"
#import "UZCustomCell.h"
#import "UZDataListCell.h"
#import "UZCityVC.h"
#import "UZDatePicker.h"

#import "UZCityCell.h"
#import "UZSearchPoint.h"
#import "UZPoint.h"
#import "UZCustomCityView.h"
#import "UZDingzhiYouVC.h"
@interface UZCustomVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UIImageView *imageView;


@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *dayList;
@property (nonatomic,strong) NSMutableArray *themeList;
//陪伴类型
@property (nonatomic,strong) NSMutableArray *peerList;
//酒店类型
@property (nonatomic,strong) NSMutableArray *grogshopList;
@property (nonatomic,strong) NSMutableArray *budgetList;

@property (nonatomic,strong) NSMutableArray *selectCell;

@property (nonatomic,strong) NSMutableArray *phoderDataList;
@property (nonatomic,strong) UZHomeService *service;

@property (nonatomic,strong) NSMutableArray *inputDataList;

//创建城市列表的tableView
@property (nonatomic,strong) UZCustomCityView*cityView;



@end

@implementation UZCustomVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithService:(UZHomeService *)service
{
    self=[super init];
    if (self) {
        _service=service;
        _inputDataList=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
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
//    alertMessage(@"目前仅支持定制上海出发的旅游线路，我们会尽快支持其他城市");
    // Do any additional setup after loading the view from its nib.
//    _returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    [_returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    [self.postButton setBackgroundColor:[UIColor ColorRGBWithString:bgWithTextColor]];
    ViewRadius(self.postButton, 3);
    self.title=@"定制游";
    [self sendViewNameWithName:self.GAStr];
    [self initWithArr];
}

#pragma mark -private method
-(void)initWithArr
{
    _dataArr =[[NSMutableArray alloc]initWithObjects:@"出发城市",@"目的地",@"出发日期",@"行程天数",@"同伴类型",@"酒店类型",@"人均预算",@"成人",@"儿童",@"联系人",@"手机号",@"邮箱", nil];
    _dayList=[[NSMutableArray alloc]initWithObjects:@"3-5天",@"6-9天",@"10-15天",@"16天以上", nil];
    _peerList=[[NSMutableArray alloc]initWithObjects:@"携爱侣",@"陪父母",@"带孩子",@"挽闺蜜 ",@"同哥们",@"馈客户",@"三代同游",@"企业团体", nil];
    _grogshopList=[[NSMutableArray alloc]initWithObjects:@"奢华型",@"豪华型",@"舒适性",@"经济型",@"民宿", nil];
    _budgetList=[[NSMutableArray alloc]initWithObjects:@"5,000以下",@"5,001-15,000",@"15,001-30,000",@" 30,000-50,000",@"50,001以上", nil];
    _selectCell=[NSMutableArray arrayWithObjects:@"no",@"no",@"no",@"no", nil];
    _phoderDataList=[NSMutableArray arrayWithObjects:@"请输入目的地",@"请输入人数",@"请输入人数",@"请输入姓名",@"请输入手机号",@"请输入邮箱", nil];
    _inputDataList=[[NSMutableArray alloc]init];
    for (NSUInteger i=0;i<_dataArr.count;i++) {
        [_inputDataList addObject:@""];
    }
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 100*Main_Screen_Width/320)];
    [_imageView setImage:[UIImage imageNamed:@"dingzhiyou.jpg"]];
    [_imageView setUserInteractionEnabled:YES];
    
    [_imageView addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)]];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-(isIOS7Above?64:44)-50)];
     _tableView.bounces=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableHeaderView=_imageView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"UZCustomCell" bundle:nil] forCellReuseIdentifier:@"UZCustomCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"UZDataListCell" bundle:nil] forCellReuseIdentifier:@"UZDataListCell"];
    
    [_tableView reloadData];//刷新数据
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView setContentSize:CGSizeMake(WIDTH(self.tableView), _tableView.contentSize.height)];
    [self.view addSubview:_tableView];

}
#pragma mark
#pragma mark- tpaImage
-(void)tapImage:(UITapGestureRecognizer *)tapImage
{
    UZDingzhiYouVC *dingzhiyouVC=[[UZDingzhiYouVC alloc]init];
    [self.navigationController pushViewController:dingzhiyouVC animated:YES];
}
- (IBAction)ClockPostButton:(id)sender {
    [self postMessage];//提交定制游的信息
}



-(NSArray *)getDataList:(NSUInteger)row
{
    if (row==3) {
        return _dayList;
    }
    else if (row==4)
    {
        return _peerList;
    }
    else if (row==5)
    {
        return _grogshopList;
    }
    else
        return   _budgetList;
}

#pragma mark
#pragma mark --buttonAction Event
-(void)bsBackBarClicked
{
    [_cityView removeFromSuperview];//从父视图中移除
    _cityView=nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark --UITabelViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section>2&&section<7) {
        if ([_selectCell[section-3] isEqualToString:@"yes"]) {
            return 2;
        }
        return 1;
    }
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0&&indexPath.section<_dataArr.count) {
        UZCustomCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UZCustomCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSeparatorStyleNone;
        [cell setDataTitleMessage:[_dataArr objectAtIndex:indexPath.section] withIndexPath:indexPath withPhoderList:_phoderDataList withTextList:_inputDataList ];
        cell.textFiled.delegate=self;
        return cell;
    }
    else if(indexPath.section<_dataArr.count)
    {
        UZDataListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UZDataListCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSeparatorStyleNone;
        [cell setcontentText:[self getDataList:indexPath.section] withBlock:^(NSString *message) {
            _inputDataList[indexPath.section]=message;
            for (int i=0; i<_selectCell.count; i++) {
                if ([_selectCell[i] isEqualToString:@"yes"]) {
                    [tableView beginUpdates];
                    //得到更新的行数
                    int contentCount=1;
                    NSMutableArray *rowToIndex=[[NSMutableArray alloc]init];
                    for (int j=1; j<contentCount+1; j++) {
                        NSIndexPath *indexpathToInset=[NSIndexPath indexPathForRow:j inSection:i+3];
                        [rowToIndex addObject:indexpathToInset];
                    }
                    _selectCell[i]=@"no";
                    [tableView deleteRowsAtIndexPaths:rowToIndex withRowAnimation:UITableViewRowAnimationMiddle];
                    //结束更新
                    [tableView endUpdates];
                    break;
                }
            }
            [tableView reloadData];
        }];
        return cell;
    }
    else
    {
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>2&&indexPath.section<7) {
        if (indexPath.row==0) {
            return 44;
        }
        else
        {
            return [UZDataListCell rowOfHeight:[self getDataList:indexPath.section]];
        }
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==3||section==7||section==_dataArr.count) {
        return 20;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section==3||section==7||section==_dataArr.count) {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 20)];
        [headerView setBackgroundColor:[UIColor ColorRGBWithString:@"#f5f5f5"]];
        return headerView;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [UZCityVC selectCity:self withService:_service select:^(UZCity *city) {
            _inputDataList[indexPath.section]=city.CityName;
            [tableView reloadData];
           
        } cancle:^{
            
        }];
    }
    else if (indexPath.section==2)
    {
         [self.tableView endEditing:YES];//结束编辑，，，隐藏键盘
        UZDatePicker *datePicker=[[UZDatePicker alloc]initWithDate:@""];
        [datePicker showWithOnClickOK:^(NSString *date) {
            if ([date isEqualToString:@"取消"]==false) {
                _inputDataList[indexPath.section]=date;
                [tableView reloadData];
            }
        }];
        
    }
    else if (indexPath.section>2&&indexPath.section<7)
    {
        for (int i=0; i<_selectCell.count; i++) {
            if ([_selectCell[i] isEqualToString:@"yes"]&&i!=indexPath.section-3) {
                [tableView beginUpdates];
                //得到更新的行数
                int contentCount=1;
                NSMutableArray *rowToIndex=[[NSMutableArray alloc]init];
                for (int j=1; j<contentCount+1; j++) {
                    NSIndexPath *indexpathToInset=[NSIndexPath indexPathForRow:j inSection:i+3];
                    [rowToIndex addObject:indexpathToInset];
                }
                _selectCell[i]=@"no";
                [tableView deleteRowsAtIndexPaths:rowToIndex withRowAnimation:UITableViewRowAnimationTop];
                //结束更新
                [tableView endUpdates];
                break;
            }
        }
        //得到选中的行
        [tableView beginUpdates];
        //得到更新的行数
        int contentCount=1;
        NSMutableArray *rowToIndex=[[NSMutableArray alloc]init];
        for (int i=1; i<contentCount+1; i++) {
            NSIndexPath *indexpathToInset=[NSIndexPath indexPathForRow:i inSection:indexPath.section];
            [rowToIndex addObject:indexpathToInset];
        }
        if ([[_selectCell objectAtIndex:indexPath.section-3] isEqualToString:@"no"]) {
            _selectCell[indexPath.section-3]=@"yes";
            [tableView insertRowsAtIndexPaths:rowToIndex withRowAnimation:UITableViewRowAnimationTop];
        }
        else
        {
            _selectCell[indexPath.section-3]=@"no";
            [tableView deleteRowsAtIndexPaths:rowToIndex withRowAnimation:UITableViewRowAnimationMiddle];
        }
        [tableView endUpdates];
    }
    else if (indexPath.section==_dataArr.count)
    {
        //提交信息
        [self postMessage];
    }
}



#pragma mark
#pragma mark --textFiledDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField.tag==1) {
//         [self searchWithStr:textField.text];
//    }
//}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//{
//    if (textField.tag==1) {
//        NSMutableString  *str = [NSMutableString stringWithString:textField.text];
//        if([string isEqualToString:@""])
//        {
//            [str setString:[textField.text stringByReplacingCharactersInRange:range withString:@""]];
//        }
//        else
//        {
//            [str setString:[textField.text stringByAppendingString:string]];
//        }
//        [self searchWithStr:[NSString stringWithFormat:@"%@",str]];
//    }

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _inputDataList[textField.tag]=textField.text;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
      _inputDataList[textField.tag]=textField.text;
}
-(void)searchWithStr:(NSString *)str
{
    UIWindow *win= [[UIApplication sharedApplication]keyWindow];
    if (_cityView) {
        _cityView=nil;
    }
    [self.tableView endEditing:YES];//结束编辑
    _cityView=[[UZCustomCityView alloc]initWithFrame:CGRectMake(0, 44+(isIOS7Above?20:0), WIDTH(self.view), Main_Screen_Height- 44-(isIOS7Above?20:0)) withSelectBlock:^(NSString *cityMessage) {
        [_cityView setHidden:YES];
        _inputDataList[1]=cityMessage;
        [_tableView reloadData];//数据刷新
        [self.tableView endEditing:YES];//结束编辑
    } withSearchStr:str];
    [_cityView bringSubviewToFront:self.tableView];
    [win addSubview:_cityView];
}



#pragma mark 
#pragma mark  postData
-(void)postMessage
{
    NSMutableString *UserNeeds=[[NSMutableString alloc]initWithCapacity:0];

    for (int i=0; i<_inputDataList.count; i++) {
        @autoreleasepool {
            NSString *str=[_inputDataList objectAtIndex:i];
            if (i==0) {
                if ([str isEqualToString:@""]) {
                    alertMessage(@"请选择出发的城市");
                    return;
                }
            }
            else if (i==1)
            {
                if ([str isEqualToString:@""]) {
                    alertMessage(@"请选择目的地");
                    return;
                }
            }
            else if (i==2)
            {
                if ([str isEqualToString:@""]) {
                    alertMessage(@"请选择出发日期");
                    return;
                }
            }else if (i==3)
            {
                if ([str isEqualToString:@""]) {
                    alertMessage(@"请选择行程天数");
                    return;
                }
            }
            
            else if (i==_inputDataList.count-3)
            {
                if ([str isEqualToString:@""]) {
                    alertMessage(@"请输入联系人");
                    return;
                }
            }
            else if (i==_inputDataList.count-2) {
                if (![str isLegalPhoneNumber]) {
                    alertMessage(@"请输入正确的电话号码");
                    return;
                }
            }
            else if (i==_inputDataList.count-1)
            {
                if (![str isLegalEmailAddress]) {
                    alertMessage(@"请输入正确的邮箱");
                    return;
                }
            }
            if ([str rangeOfString:@","].location!=NSNotFound) {
                str=[str stringByReplacingOccurrencesOfString:@"," withString:@""];
            }
            
            
            if (![str isEqualToString:@""]) {
                [UserNeeds insertString:str atIndex:[UserNeeds length]];
                if (i!=_inputDataList.count-1) {
                    [UserNeeds insertString:@"," atIndex:[UserNeeds length]];
                }
            }
            else
            {
                if (i==_inputDataList.count-4||i==_inputDataList.count-5) {
                    [UserNeeds insertString:@"0" atIndex:[UserNeeds length]];
                }
                else
                {
                    [UserNeeds insertString:@"" atIndex:[UserNeeds length]];
                }
                
                if (i!=_inputDataList.count-1) {
                    [UserNeeds insertString:@"," atIndex:[UserNeeds length]];
                }
            }
        }
    }
    NSString *userId=UZ_CLIENT.UserID?UZ_CLIENT.UserID:[NSString stringWithFormat:@"0"];
    [self showLoadingWithMessage:nil];
    [_service DingzhiyouWithUserID:userId UserNeeds:UserNeeds SuccessBlock:^{
        [self hideLoading];
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alterView show];
    } withFiledBlock:^(NSString *code, NSString *msg) {
        [self hideLoading];
        alertMessage(msg);
    }];

}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    [_textFiledView resignFirstResponder];//失去第一响应者
//    UZCustomCell *cell=(UZCustomCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    [cell.textFiled resignFirstResponder];
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
