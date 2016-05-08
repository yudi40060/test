//
//  UZDestinationPicker.m
//  UZai5.2
//
//  Created by uzai on 14-9-12.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZDestinationPicker.h"
#import "UIColor+RGBString.h"
#import "UZHomeClass.h"
#import "Tool.h"

@interface UZDestinationPicker ()

@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation UZDestinationPicker
{
    UIView *subView;
    
    NSUInteger selectIndex;
    
    NSUInteger rightSelectIndex;
    NSMutableArray *arrayWithData;
    BOOL isDidDraw;
}

- (void)loadContentView {
    // 加载contentView
    [[NSBundle mainBundle] loadNibNamed:@"UZDestinationPicker" owner:self options:nil];
    
    // 添加到视图上
    [self addSubview:self.contentView];
}

-(id)initWithService:(UZListPageService *)service
{
    self=[super init];
    if (self) {
        _service=service;
        arrayWithData=[NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadContentView];
        // Initialization code
        self.tableViewLeft.delegate=self;
        self.tableViewLeft.dataSource=self;
        self.tableViewRight.delegate=self;
        self.tableViewRight.dataSource=self;
        self.tableViewLeft.selectViewBgColor = [UIColor ColorRGBWithString:@"#ffeff4"];
        self.tableViewRight.selectViewBgColor = [UIColor ColorRGBWithString:@"#fff8fa"];
            
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
-(void)reload
{
    selectIndex=0;
    [arrayWithData removeAllObjects];
    [arrayWithData addObjectsFromArray:_service.listPageCityList];
    [self getHistorySelect];
    [self.tableViewLeft reloadData];
    [self.tableViewRight reloadData];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:selectIndex inSection:0];
    NSIndexPath *indexPathRight=[NSIndexPath indexPathForRow:rightSelectIndex inSection:0];
    
    if (arrayWithData.count>0) {
         [self.tableViewLeft.contentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        UZHomeClass *preDestination = [arrayWithData objectAtIndex:selectIndex];
        if (preDestination.navLink.count>0) {
            [self.tableViewRight.contentTableView scrollToRowAtIndexPath:indexPathRight atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             }
    }
}
-(void)getHistorySelect
{
    selectIndex=0;
    rightSelectIndex=0;
    if (_service.listPageModel.preDestinationID.length!=0) {
        for (int i=0; i<[arrayWithData count]; i++) {
            UZHomeClass *preDestination = [arrayWithData objectAtIndex:i];
            if (([preDestination.subClass.ID isEqualToString:_service.listPageModel.preDestinationID]&&_service.listPageModel.preDestinationID.integerValue!=0)||([preDestination.subClass.NavLinkName isEqualToString:_service.listPageModel.preDestination]&&_service.listPageModel.preDestinationID.integerValue==0)) {
                selectIndex=i;
                
                for (int j=0; j<preDestination.navLink.count; j++) {
                    
                    UZHomeSubClass *destination=preDestination.navLink[j];
                    if ([destination.NavLinkName isEqualToString:_service.listPageModel.destination]) {
                        rightSelectIndex=j;
                        _service.listPageModel.searchKeyword = destination.MobileSearchKeyWord;
                        break;
                    }
                }
            }
            
        }
    }
}

-(void)showWithOnClick:(void (^)(id))onclickBlock
{
    _onclik=onclickBlock;
    
    self.frame=CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 282);
    self.contentView.frame = self.bounds;
    [subView setFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-50)];
    __weak UZDestinationPicker *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [subView setAlpha:1.0];
        [weakSelf setFrame:CGRectMake(0, Main_Screen_Height-282-50, Main_Screen_Width, 282)];
    } completion:^(BOOL finished) {
        [weakSelf reload];
    }];
    
    [subView addSubview:self];
    _showState=YES;
    
}
-(void)tap:(id)sender
{
    [self hideWithStr:nil];
}

-(void)hideWithStr:(NSString *)str
{
    __weak UZDestinationPicker *weakSelf = self;
    [UIView animateWithDuration:0.45 animations:^{
        [weakSelf setFrame:CGRectMake(0, 768, App_Frame_Width, 170)];
        [subView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    _showState=NO;
    BLOCK_SAFE(_onclik)(str);
}

#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    if (arrayWithData.count==0) {
        return 0;
    }
    
    if (valueSelector==self.tableViewLeft) {
        return arrayWithData.count;
    }
    UZHomeClass *preDestination = [arrayWithData objectAtIndex:selectIndex];
    return preDestination.navLink.count;
}



//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    
    return 47;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return WIDTH(valueSelector);
}


- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index
{
    UILabel * label = nil;

    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(valueSelector), 47)];
  
    label.text = [NSString stringWithFormat:@"%ld",(long)index];
    label.textAlignment =  NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.backgroundColor = [UIColor clearColor];
    
    if (valueSelector==self.tableViewLeft) {
        UZHomeClass *preDestination = [arrayWithData objectAtIndex:index];
        label.text=preDestination.subClass.NavLinkName;
        if (index == selectIndex) {
            label.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
        }else
        {
            label.textColor = bg66Color;
        }
    }else
    {
        UZHomeClass *preDestination = [arrayWithData objectAtIndex:selectIndex];
        NSMutableArray *destinationDTO=preDestination.navLink;
        UZHomeSubClass *destination=destinationDTO[index];
        
        label.text=destination.NavLinkName;
        if (index == rightSelectIndex) {
            label.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
        }else
        {
            label.textColor = bg66Color;
        }
    }
    return label;
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    return CGRectMake(0, 47, WIDTH(valueSelector), 47);
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index
{
    if (valueSelector == self.tableViewLeft) {
        selectIndex = index;
        rightSelectIndex = 0;
        [self.tableViewRight.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else
    {
        rightSelectIndex = index;
    }
    [self.tableViewLeft reloadData];
    [self.tableViewRight reloadData];
}

- (IBAction)onclickCancle:(id)sender {
    [self hideWithStr:nil];
}
- (IBAction)onclickOK:(id)sender {

    UZHomeClass *preDestination = [arrayWithData objectAtIndex:selectIndex];
    NSMutableArray *destinationDTO=preDestination.navLink;
    UZHomeSubClass *destination=destinationDTO[rightSelectIndex];
    
    _service.listPageModel.destination=destination.NavLinkName;
    _service.listPageModel.preDestination=preDestination.subClass.NavLinkName;
    _service.listPageModel.preDestinationID=preDestination.subClass.ID;
    _service.listPageModel.preDestinationSearchKeyword=preDestination.subClass.MobileSearchKeyWord;
    //其他筛选条件清空
    _service.listPageModel.orderBy = 1;
    self.service.listPageModel.dayRangeID=0;
    self.service.listPageModel.priceRangeID=0;
    self.service.listPageModel.goDateCondition=nil;
    self.service.listPageModel.diamond = 0;
    [self hideWithStr:[destination.MobileSearchKeyWord isEqualToString:@"不限"]?preDestination.subClass.NavLinkName:destination.MobileSearchKeyWord];
    
}

@end

