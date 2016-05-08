//
//  UZCustomCityView.m
//  UZai5.2
//
//  Created by UZAI on 14-9-19.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZCustomCityView.h"
#import "UZCityCell.h"
#import "UZPoint.h"
#import "UZCustomCell.h"
#import "UZSearchPoint.h"
#import "UZBottomCellView.h"
#import "UZSearchBar.h"
@interface UZCustomCityView()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *CityListTableView;
@property (nonatomic,strong) NSMutableArray *cityList;
@property (nonatomic,copy) void (^selectBlock)(NSString *cityMessage);
@property (nonatomic,strong)  NSMutableString *str;
@property (nonatomic,strong) UZSearchBar *textFiled;

//@property (nonatomic,strong) NSString *
@end
@implementation UZCustomCityView

- (id)initWithFrame:(CGRect)frame withSelectBlock:(void(^)(NSString *cityMessage))selectBlock  withSearchStr:(NSString *)searchStr
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 11, WIDTH(self), 22)];
        [headerLabel setText:@"目的地"];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setTextColor:[UIColor blackColor]];
        [headerLabel setFont:[UIFont systemFontOfSize:16.0]];
        [headerView addSubview:headerLabel];
        
        _textFiled=[[UZSearchBar alloc]initWithFrame:CGRectMake(100, 3, 210, 39)];
        _textFiled.delegate=self;
        _textFiled.text=_str;
        [_textFiled becomeFirstResponder];
        _textFiled.placeholder=@"请输入目的地";
        [headerView addSubview:_textFiled];
        
        
        UZBottomCellView *cellView=[[UZBottomCellView alloc]initWithFrame:CGRectMake(0, 43.5, WIDTH(self), 0.5)];
        [headerView addSubview:cellView];
        
        

        _selectBlock=selectBlock;
        _CityListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
        _CityListTableView.dataSource=self;
        _CityListTableView.delegate=self;
        _CityListTableView.bounces=NO;
        _CityListTableView.tableHeaderView=headerView;
        _CityListTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_CityListTableView registerNib:[UINib nibWithNibName:@"UZCityCell" bundle:nil] forCellReuseIdentifier:@"UZCityCell"];
        [self addSubview:_CityListTableView];
        [_textFiled becomeFirstResponder];
        [self searchWithStr:searchStr];
    }
    return self;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UZCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UZCityCell" forIndexPath:indexPath];
    UIImageView *imageview_normal = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, App_Frame_Width, 46.0)];
    imageview_normal.image = [UIImage imageNamed:@"cellbackground_normal_46"];
    cell.backgroundView = imageview_normal;
    
    UIImageView *imageview_select = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, App_Frame_Width, 46.0)];
    imageview_select.image = [UIImage imageNamed:@"cellbackground_select_46"];
    cell.selectedBackgroundView = imageview_select;
    [cell.bottomView setHidden:YES];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UZPoint *point=[self.cityList objectAtIndex:indexPath.row];
    cell.cityNameLabel.text=point.KeyWord;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UZPoint *point=[self.cityList objectAtIndex:indexPath.row];
    _textFiled.text =@"";
    _cityList=nil;
    [_CityListTableView reloadData];
    [_textFiled resignFirstResponder];//失去第一响应
    BLOCK_SAFE(_selectBlock)(point.KeyWord);
    [self setHidden:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row==0) {
//        return 44;
//    }
    return 46;
}
#pragma mark
#pragma mark --textFiledDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
   _str = [NSMutableString stringWithString:textField.text];
    if([string isEqualToString:@""])
    {
        [_str setString:[textField.text stringByReplacingCharactersInRange:range withString:@""]];
    
    }
    else
    {
        _str=[NSMutableString stringWithFormat:@"%@%@",_str,string];
    }
    [self searchWithStr:_str];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchWithStr:textField.text];
    [textField resignFirstResponder];
    return YES;
}
-(void)searchWithStr:(NSString *)str
{
    if ([str isEqualToString:@""]) {
        [self setHidden:YES];
        [_textFiled resignFirstResponder];//失去第一响应
        BLOCK_SAFE(_selectBlock)(@"");//失去页面刷新
    }
    else
    {
        [_cityList removeAllObjects];
        _cityList=[NSMutableArray arrayWithArray:[UZSearchPoint QueryPointList:str]];
        if (_cityList.count>0) {
            [_CityListTableView reloadData];
            self.hidden=NO;
        }
        else
        {
//            self.hidden=YES;
             [_CityListTableView reloadData];
        }
        [_textFiled becomeFirstResponder];//变成第一响应者
    }
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchWithStr:searchText];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
