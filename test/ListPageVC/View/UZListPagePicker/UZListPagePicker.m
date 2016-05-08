//
//  UZListPagePicker.m
//  UZai5.2
//
//  Created by uzai on 14-9-10.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZListPagePicker.h"
#import "UIColor+RGBString.h"
#import "UZListPageDatePickerCell.h"
#import "UZDestinationClass.h"
#import "UZDestinationDTO.h"
#import "DiamondLevelView.h"

@interface UZListPagePicker ()

@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation UZListPagePicker
{
    UIView *subView;
    
    NSUInteger selectIndex;
    NSUInteger rightnSelectIndex;
    
    NSMutableArray *arrRight;
    NSMutableArray *arrayLeft;
    
    NSUInteger dayRangeID;
    NSUInteger priceRangeID;
    NSUInteger diamond;
    NSString *goDateCondition;
    NSString *searchKeyword;
    
    UZListPageDatePickerCell *viewDatePicker;
    DiamondLevelView *diamondLevelView;
    
    BOOL isDidDraw;
}

- (void)loadContentView {
    [[NSBundle mainBundle]loadNibNamed:@"UZListPagePicker" owner:self options:nil];
    [self addSubview:self.contentView];
}

-(id)initWithService:(UZListPageService *)service
{
    self=[super init];
    if (self) {
        _service=service;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadContentView];
        self.tableViewLeft.delegate=self;
        self.tableViewLeft.dataSource=self;
        self.tableViewRight.delegate=self;
        self.tableViewRight.dataSource=self;
        self.tableViewLeft.selectViewBgColor = [UIColor ColorRGBWithString:@"#ffeff4"];
        self.tableViewRight.selectViewBgColor = [UIColor ColorRGBWithString:@"#fff8fa"];
        selectIndex=0;
        rightnSelectIndex = 0;
        
        ViewBorderRadius(self.btnReset, 2, 0.5, [UIColor ColorRGBWithString:@"#cccccc"]);
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
-(void)reload
{
    //selectIndex=0;
    [self loadData];
    [self.tableViewLeft reloadData];
    [self.tableViewRight reloadData];
}
-(void)loadCondition
{
    goDateCondition = self.service.listPageModel.goDateCondition;
    dayRangeID = self.service.listPageModel.dayRangeID;
    priceRangeID = self.service.listPageModel.priceRangeID;
    searchKeyword = self.service.listPageModel.searchKeyword;
    diamond = self.service.listPageModel.diamond;
}
-(void)loadData
{
    [self loadCondition];
    NSArray *arrRight1=@[@"不限",@"1-2天",@"3-5天",@"6-8天",@"9-11天",@"11天以上"];
    NSArray *arrRight2=@[@"不限",@"1-500元",@"501-1000元",@"1001-3000元",@"3001-5000元",@"5001-8000元",@"8001-10000元",@"10000元以上"];
    NSArray *arrRight3=@[@"不限",@"六钻",@"五钻",@"四钻",@"三钻"];
    arrRight=[NSMutableArray arrayWithObjects:arrRight1,arrRight2,@[],arrRight3,[NSArray array],nil];
    
    arrayLeft=[NSMutableArray arrayWithObjects:@"出行天数",@"价格区间",@"出行日期",@"产品等级", nil];
    for (UZDestinationClass *des in _service.listPageModel.arrWithDestinationClass) {
        
        NSMutableArray *arrTmep=[NSMutableArray arrayWithCapacity:0];
        for (UZDestinationDTO *dto in des.destinationDTO) {
            [arrTmep addObject:dto];
        }
        [arrRight addObject:arrTmep];
        
        if (arrTmep.count>0) {
            UZDestinationDTO *dto=arrTmep[0];
            if (dto.MobileSearchKeyWord.length>0) {
                [arrayLeft addObject:des.NavLinkName];
            }
            
        }
    }
    if (selectIndex==0) {
        [self.tableViewRight.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dayRangeID inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else if (selectIndex == 1)
    {
        [self.tableViewRight.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:priceRangeID inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    if (viewDatePicker) {
        [viewDatePicker reloadWithDateStr:goDateCondition];
    }
    if (diamondLevelView) {
        [diamondLevelView setSelectIndex:diamond];
    }
}
-(void)showWithOnClick:(void (^)(id))onclickBlock
{
    _onclik=onclickBlock;

    self.frame=CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 282);
    self.contentView.frame = self.bounds;
    [subView setFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-50)];
    __block UZListPagePicker *blockSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        subView.alpha=1.0;
        [blockSelf setFrame:CGRectMake(0, Main_Screen_Height-282-50, Main_Screen_Width, 282)];
        if (!isDidDraw) {
            [blockSelf reload];
        }else
        {
            [blockSelf loadCondition];
            [blockSelf.tableViewLeft.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [blockSelf didSelectLeftWithIndex:0];
        }
        
    }];
    
    [subView addSubview:self];
    _showState=YES;
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    [self hiden:nil];
}
-(void)hiden:(NSString *)message
{
    __block UZListPagePicker *blockSelf = self;
    [UIView animateWithDuration:0.45 animations:^{
        [blockSelf setFrame:CGRectMake(0, 768, App_Frame_Width, 170)];
        [subView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [blockSelf removeFromSuperview];
    }];
    _showState=NO;
    BLOCK_SAFE(_onclik)(message);
}
- (IBAction)onclick:(id)sender {
    self.service.listPageModel.orderBy = 1;
    self.service.listPageModel.dayRangeID=dayRangeID;
    self.service.listPageModel.priceRangeID=priceRangeID;
    self.service.listPageModel.goDateCondition=goDateCondition;
    self.service.listPageModel.searchKeyword=searchKeyword;
    self.service.listPageModel.diamond = diamond;
    [self hiden:@"dd"];
    [self.listPageVC sendEventWithLable:@"confirm" andScreenName:@"线路列表页" andCategory:[self.listPageVC travelGAStrCategory] andAction:@"filter"];
}
- (IBAction)onclickCancel:(id)sender {
    [self hiden:nil];
      [self.listPageVC sendEventWithLable:@"cancel" andScreenName:@"线路列表页" andCategory:[self.listPageVC travelGAStrCategory] andAction:@"filter"];
}
- (IBAction)onclickReset:(id)sender {
    dayRangeID=0;
    priceRangeID=0;
    diamond=0;
    goDateCondition=nil;
    searchKeyword=nil;
   
    [_tableViewLeft reloadData];
    [_tableViewRight reloadData];
    [self.tableViewRight.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if (viewDatePicker) {
         [viewDatePicker reloadWithDateStr:goDateCondition];
    }
    if (diamondLevelView) {
        [diamondLevelView setSelectIndex:diamond];
    }
    [self.listPageVC sendEventWithLable:@"reset" andScreenName:@"线路列表页" andCategory:[self.listPageVC travelGAStrCategory] andAction:@"filter"];
}
#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    if (valueSelector==_tableViewLeft) {
        return arrayLeft.count;
    }else
    {
        if (selectIndex==2) {
            return 1;
        }
        else  {
             return  [arrRight[selectIndex] count];
        }
    }
    
    return 0;
}



//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    if (valueSelector==self.tableViewRight&&selectIndex==2) {
        return HEIGHT(valueSelector);
    }
    return 47;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return WIDTH(valueSelector);
}


- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index
{

    UILabel * label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(valueSelector), 47)];
    
    label.textAlignment =  NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageFlag=[[UIImageView alloc]initWithFrame:CGRectMake(100, 8, 7, 7)];
    imageFlag.backgroundColor = [UIColor ColorRGBWithString:bgWithTextColor];
    imageFlag.layer.cornerRadius = 3.5;
    imageFlag.layer.masksToBounds = YES;
    imageFlag.tag=1001;
    [label addSubview:imageFlag];
    if (valueSelector == self.tableViewLeft) {
        label.text=arrayLeft[index];
        if (index==selectIndex) {

            label.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
            imageFlag.backgroundColor = [UIColor ColorRGBWithString:bgWithTextColor];
        }
        else
        {
            label.textColor = bg66Color;
            imageFlag.backgroundColor = [UIColor ColorRGBWithString:@"#fb84a2"];
        }
        if (index==0) {
            if (dayRangeID==0) {
                imageFlag.hidden=YES;
            }else
            {
                imageFlag.hidden=NO;
            }
        }else if (index==1)
        {
            if (priceRangeID==0) {
                imageFlag.hidden=YES;
            }else
            {
                imageFlag.hidden=NO;
            }
        }else if (index==2)
        {
            if (goDateCondition==0||[goDateCondition isEqualToString:@"不限"]) {
                imageFlag.hidden=YES;
            }else
            {
                imageFlag.hidden=NO;
            }
        }else if (index==3)
        {
            if (diamond==0) {
                imageFlag.hidden=YES;
            }else
            {
                imageFlag.hidden=NO;
            }
        }

    }else
    {
        imageFlag.hidden = YES;
        if (selectIndex==2) {

        }else
        {
            label.text=arrRight[selectIndex][index];
     
            if ((selectIndex==0&&dayRangeID==index)||(selectIndex==1&&priceRangeID==index)||(selectIndex==3&&diamond==index)) {
                
                label.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
            }
            else
            {
                label.textColor = bg66Color;
            }
        }
        
    }

    return label;
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    return CGRectMake(0, 47, WIDTH(valueSelector), 47);
}
-(void)didSelectLeftWithIndex:(NSInteger)index
{
    selectIndex = index;
    [self.tableViewLeft reloadData];
    [self.tableViewRight reloadData];
    if (index==0) {
        [self.tableViewRight.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dayRangeID inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [viewDatePicker removeFromSuperview];
        [diamondLevelView removeFromSuperview];
    }else if (index == 1)
    {
        [self.tableViewRight.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:priceRangeID inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [viewDatePicker removeFromSuperview];
        [diamondLevelView removeFromSuperview];
    }
    else if (index==2) {
        [diamondLevelView removeFromSuperview];
        [viewDatePicker removeFromSuperview];
        viewDatePicker=[[[NSBundle mainBundle]loadNibNamed:@"UZListPageDatePickerCell" owner:nil options:nil]objectAtIndex:0];
        viewDatePicker.frame = self.tableViewRight.frame;
        viewDatePicker.goDateCondition=goDateCondition;
        __block UZListPagePicker *blockSelf = self;
        [viewDatePicker ShowWithSelect:^(id data) {
            goDateCondition=data;
            [blockSelf.tableViewLeft reloadData];
        }];
        [self addSubview:viewDatePicker];
    }else
    {
        [viewDatePicker removeFromSuperview];
        if (!diamondLevelView) {
            diamondLevelView = [[DiamondLevelView alloc]initWithFrame:self.tableViewRight.frame];
            __block UZListPagePicker *blockSelf = self;
            [diamondLevelView selectIndex:^(NSUInteger index) {
                diamond = index;
                [blockSelf.tableViewLeft reloadData];
            }];
        }
        [diamondLevelView setSelectIndex:diamond];
        [self addSubview:diamondLevelView];
    }
}
#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index
{
    if (valueSelector == self.tableViewLeft) {
        [self didSelectLeftWithIndex:index];
        [self.listPageVC sendEventWithLable:arrayLeft[index] andScreenName:@"线路列表页" andCategory:[self.listPageVC travelGAStrCategory] andAction:@"filter"];
    }else
    {
        rightnSelectIndex = index;
        if (selectIndex==0) {
            dayRangeID=index;
        }else if (selectIndex==1)
        {
            priceRangeID=index;
        }else if(selectIndex==3)
        {
            diamond=index;
        }
        [self.tableViewLeft reloadData];
        [self.tableViewRight reloadData];
    }
   
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!isDidDraw) {
        CGFloat height = 1.0/self.contentScaleFactor;
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.backgroundColor = [UIColor ColorRGBWithString:@"#cccccc"].CGColor;
        lineLayer.frame = CGRectMake(0,47-height, rect.size.width, height);
        [self.layer addSublayer:lineLayer];
        
        CALayer *lineLayer1 = [[CALayer alloc] init];
        lineLayer1.backgroundColor = [UIColor ColorRGBWithString:@"#FFDEE6"].CGColor;
        lineLayer1.frame = CGRectMake(0,47*2-height, rect.size.width, height);
        [self.layer addSublayer:lineLayer1];
        
        CALayer *lineLayer2 = [[CALayer alloc] init];
        lineLayer2.backgroundColor = [UIColor ColorRGBWithString:@"#FFDEE6"].CGColor;
        lineLayer2.frame = CGRectMake(0,47*3-height, rect.size.width, height);
        [self.layer addSublayer:lineLayer2];
        isDidDraw = YES;
    }
    
}

@end
