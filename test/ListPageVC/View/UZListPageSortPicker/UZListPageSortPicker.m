//
//  UZListPageSortPicker.m
//  UZai5.2
//
//  Created by uzai on 14-9-11.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZListPageSortPicker.h"
#import "UIColor+RGBString.h"

@interface UZListPageSortPicker ()

@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation UZListPageSortPicker

- (void)loadContentView {
    [[NSBundle mainBundle]loadNibNamed:@"UZListPageSortPicker" owner:nil options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadContentView];
        self.myTableView.delegate=self;
        self.myTableView.dataSource=self;
        arrWithData=[NSArray arrayWithObjects:@"按推荐热门排序",@"价格从低到高",@"价格从高到低",@"销量从高到低",@"销量从低到高", nil];
        
        UIWindow *win= [Tool getAppDelegate].window;
        subView=[[UIView alloc] init];
        [subView setAlpha:0];
        
        UIView *viewBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-50)];
        viewBg.layer.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        [subView addSubview:viewBg];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [viewBg addGestureRecognizer:tap];
        
        [win addSubview:subView];
    }
    return self;
}
-(id)initWithService:(UZListPageService *)service
{
    self=[super init];
    if (self) {
        _service=service;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)showWithOnClick:(void (^)(id))onclickBlock{
     _onclik=onclickBlock;
    
    
    self.frame=CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 308);
    [subView setFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-50)];
    [UIView animateWithDuration:0.3 animations:^{
         [subView setAlpha:1.0];
        [self setFrame:CGRectMake(0, Main_Screen_Height-245-50, Main_Screen_Width, 245)];
    }];
    
    [subView addSubview:self];
    _showState=YES;
    [self.myTableView reloadData];
}
-(void)tap:(id)sender
{
    [self hideWithMessage:nil];
}
-(void)hideWithMessage:(id)data
{
    _showState=NO;
    [UIView animateWithDuration:0.45 animations:^{
        [self setFrame:CGRectMake(0, 768, App_Frame_Width, 170)];
        [subView setAlpha:0.0];
    }];
    
    BLOCK_SAFE(_onclik)(data);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"identifer";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.textColor=[UIColor ColorRGBWithString:RGBStringColor];
        
        cell.backgroundView=nil;
        cell.textLabel.backgroundColor=[UIColor clearColor];
        UIView *bgView=[[UIView alloc]initWithFrame:cell.frame];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.backgroundView=bgView;
        
        UIImageView *imageSelect=[[UIImageView alloc]initWithFrame:CGRectMake(App_Frame_Width-30,15, 13, 10)];
        imageSelect.tag=1002;
        imageSelect.contentMode=UIViewContentModeScaleAspectFit;
        imageSelect.image=[UIImage imageNamed:@"icon_duigou"];
        [cell.contentView addSubview:imageSelect];
//        UIImageView *imageview_select = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, App_Frame_Width, 44.0)];
//        imageview_select.backgroundColor=[UIColor ColorRGBWithString:@"#def3e6"];
//        cell.selectedBackgroundView = imageview_select;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            
            [cell setPreservesSuperviewLayoutMargins:NO];
            
        }
    }
    UIImageView *imageSelect=(UIImageView *)[cell.contentView viewWithTag:1002];
    cell.textLabel.text=arrWithData[indexPath.row];
    if (_service.listPageModel.orderBy==[self formatWithNum:indexPath.row]) {
        imageSelect.hidden=NO;
        cell.textLabel.textColor=[UIColor ColorRGBWithString:bgWithTextColor];
    }else
    {
        imageSelect.hidden=YES;
        cell.textLabel.textColor=[UIColor ColorRGBWithString:RGBStringColor];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWithData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // 1推荐热门，2价格升序，3销量降序，4推荐冷门，5价格降序，6，销售量升序）

    _service.listPageModel.orderBy=[self formatWithNum:indexPath.row];
   
    [self hideWithMessage:[NSNumber numberWithInteger:indexPath.row]];
    

}
-(int)formatWithNum:(NSInteger)num
{
    if (num==0) {
        return 1;
    }else if (num==1)
    {
        return  2;
    }else if (num==2)
    {
        return 5;
    }else if (num==3)
    {
        return 3;
    }else if (num==4)
    {
        return 6;
    }
    return 0;
}
@end
