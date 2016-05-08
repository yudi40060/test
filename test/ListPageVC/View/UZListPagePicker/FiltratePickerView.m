//
//  FiltratePickerView.m
//  Uzai
//
//  Created by UZAI on 14-7-14.
//
//

#import "FiltratePickerView.h"

@interface FiltratePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    int flag;
    
    BOOL noDay;
}
@property (nonatomic,strong) UIPickerView *datePicker;
@property (nonatomic,strong) NSArray *fontAry;
@property (nonatomic,strong) NSArray *WeekList;

@property (nonatomic,strong) PickerDate *pickDate;
//定义年月的数组
@property (nonatomic,strong) NSMutableArray *yearWithMonthList;
@property (nonatomic,strong) NSMutableArray *AllYearWithMonthList;
@property (nonatomic,strong) NSMutableArray *dayWithWeekList;
@property (nonatomic,strong) NSMutableArray *AllDayWithWeekList;
@end
@implementation FiltratePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(id)initWithDateStr:(NSString *)dateStr andRect:(CGRect)rect
{
    self=[super init];
    if (self) {
        [self initWithData];
        // Initialization code
        _fontAry=[UIFont familyNames];
        _datePicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        _datePicker.dataSource=self;
        _datePicker.delegate=self;
        
        [self addSubview:_datePicker];
        
        [self reloadWithDateStr:dateStr];
    }
    return self;
}
-(void)reloadWithDateStr:(NSString *)dateStr
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *strDate=[[dateStr componentsSeparatedByString:@" "]objectAtIndex:0];
    NSDate *date=[formatter dateFromString:strDate];
    if (!date) {
        [formatter setDateFormat:@"yyyy年MM月"];
        date=[formatter dateFromString:strDate];
        noDay=YES;
    }
    
    self.date=date;
    
    for (int i=0; i<1; i++) {
        @autoreleasepool {
            if (self.date) {
                NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM"];
                int selectMonth=[[formatter stringFromDate:self.date]intValue];
                int currentMonth=[[formatter stringFromDate:[NSDate date]]intValue];
                
                [formatter setDateFormat:@"yyyy"];
                int selectYear=[[formatter stringFromDate:self.date]intValue];
                int currentYear=[[formatter stringFromDate:[NSDate date]]intValue];
                
                [_datePicker selectRow:abs((selectYear-currentYear)*12+selectMonth-currentMonth)+1+ _AllYearWithMonthList.count/2  inComponent:i animated:NO];
            }else
            {
                [_datePicker selectRow:_AllYearWithMonthList.count/2 inComponent:i animated:NO];
            }
        }
    }
    [self reloadSelectPicker];///刷新picker的数据
}
#pragma private method
-(void)initWithData
{
    //初始化星期
    _WeekList=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",
               nil];
    _yearWithMonthList=[[NSMutableArray alloc]initWithCapacity:0];
    //得到当前的年月
    NSDate*dateC;
   
    dateC = [NSDate date];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps=[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:dateC];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    PickerDate *da=[[PickerDate alloc]init];
    da.year=year;
    da.month=month;
    da.yearWithMonthString=@"不限";
    [_yearWithMonthList addObject:da];
    //定义一个布尔值，判定是否添加1
    BOOL IsYearAdd=NO;
    for (int i=0; i<12; i++) {
        
        if (month>12) {
            month=month-12;
            if (!IsYearAdd) {
                year=year+1;
                IsYearAdd=YES;
            }
        }
        PickerDate *date=[[PickerDate alloc]init];
        date.year=year;
        date.month=month;
        date.yearWithMonthString=[NSString stringWithFormat:@"%ld年-%ld月",(long)year,(long)month];
        [_yearWithMonthList addObject:date];
        month=month+1;
    }
    _AllYearWithMonthList=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<[_yearWithMonthList count]*100; i++) {
        PickerDate *date1=[_yearWithMonthList objectAtIndex:i%13];
        [_AllYearWithMonthList addObject:date1];
    }
    //默认是7月份
    [self getdayWithWeek:[_yearWithMonthList objectAtIndex:1]];
}

///获得是星期几的
-(void)getdayWithWeek:(PickerDate *)date
{
    //初始化天数和时间
    _dayWithWeekList =nil;
    _dayWithWeekList=[[NSMutableArray alloc]init];
    //清空天数和时间 的总数
    _AllDayWithWeekList=nil;
    //初始化
    _AllDayWithWeekList=[[NSMutableArray alloc]initWithCapacity:0];
    
    
    NSUInteger days;
    if (date.year%4==0&&date.month==2) {
        //这里表示闰年
        days=29;
    }
    else
    {
        if (date.month==2) {
            days=28;
        }
        else
        {
            if (date.month==1||date.month==3||date.month==5||date.month==7||date.month==8||date.month==10||date.month==12) {
                //这里表示每个月是31天
                days=31;
            }
            else
            {
                days=30;
            }
        }
    }
    //首先添加不限的的数据
    PickerDate *buxianDate=[[PickerDate alloc]init];
    buxianDate.day=0;
    buxianDate.weekIndex=0;
    if (![date.yearWithMonthString isEqualToString:@"不限"]) {
        buxianDate.year=date.year;
        buxianDate.month=date.month;
    }
    buxianDate.dayWithWeekString=@"不限";
    [_dayWithWeekList addObject:buxianDate];
    buxianDate=nil;
    for (int i=0; i<days; i++) {
        PickerDate *date1=[[PickerDate alloc]init];
        date1.day=i+1;
        if (![date.yearWithMonthString isEqualToString:@"不限"]) {
            date1.year=date.year;
            date1.month=date.month;
        }
        
        date1.weekIndex= GetWeekdays(date.year, date.month, date1.day);
        date1.dayWithWeekString=[NSString stringWithFormat:@"%lu日-%@",(unsigned long)date1.day,[_WeekList objectAtIndex:date1.weekIndex]];
        [_dayWithWeekList addObject:date1];
        date1=nil;
    }
    
    ///循环添加1000次的数据
    for (int i=0; i<_dayWithWeekList.count*100; i++) {
        PickerDate *date1=[_dayWithWeekList objectAtIndex:i%_dayWithWeekList.count];
        [_AllDayWithWeekList addObject:date1];
    }
    [self reloadSelectPicker];
//    [_datePicker reloadComponent:1];
}


///根据年月日计算星期的
NSUInteger  GetWeekdays ( NSUInteger uYear, NSUInteger   uMonth,  NSUInteger  uDay )
{
	NSUInteger a = (14 - uMonth) / 12;
	NSUInteger y = uYear - a;
	NSUInteger m = uMonth + 12 * a - 2;
	NSUInteger d = (uDay + y + y / 4 - y / 100 + y / 400 + 31 * m / 12) % 7;
    return d;
}

///刷新pickerView的数据
-(void)reloadSelectPicker
{
    for (int i = 0; i < 2; i++) {
        @autoreleasepool {
            if (i==1) {
                if (self.date&&flag<2) {
                    
                    if (noDay) {
                        [_datePicker selectRow:_AllDayWithWeekList.count/2 inComponent:i animated:NO];
                        if (flag==1) {
                            noDay=NO;
                        }
                    }else
                    {
                        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"dd"];
                        NSString *day=[formatter stringFromDate:self.date];
                        [_datePicker selectRow:[day intValue]+ _AllDayWithWeekList.count/2 inComponent:i animated:NO];
                    }
                    flag++;
                }else
                {
                    [_datePicker selectRow:_AllDayWithWeekList.count/2 inComponent:i animated:NO];
                }
                
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRectgoDate=[NSString stringWithFormat:@"%@..",productModel.GoDate];CGRect)rect
{
    // Drawing code
}
*/



#pragma pickerView dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ([_AllDayWithWeekList count]>0) {
        return 2;
    }
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==1) {
        return [_AllDayWithWeekList count];
    }
    return [_AllYearWithMonthList count];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    return 105;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    return 30;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *str=@"";
    if (component==0) {
        PickerDate *date=[_AllYearWithMonthList objectAtIndex:row];
        str=date.yearWithMonthString;
    }
    else
    {
        PickerDate *date=[_AllDayWithWeekList objectAtIndex:row];
        str=date.dayWithWeekString;
    }
    return str;
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumScaleFactor = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.textColor = bg66Color;
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

///*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    BOOL __unused isSwitchLeft=NO;
    if (component==0) {
        PickerDate *date=[_AllYearWithMonthList objectAtIndex:row];
        NSString *yearWithMonthString = date.yearWithMonthString;
        [self  getdayWithWeek:date];
        _pickDate=nil;
        _pickDate=[[PickerDate alloc]init];//重新初始化数据
        _pickDate.year=date.year;
        _pickDate.month=date.month;
        _pickDate.yearWithMonthString=yearWithMonthString;
        [pickerView reloadComponent:1];
        isSwitchLeft=YES;
    }
    else
    {
        PickerDate *date=[_AllDayWithWeekList objectAtIndex:row];
        _pickDate=nil;
        _pickDate=[[PickerDate alloc]init];//重新初始化数据
        _pickDate.day=date.day;
        _pickDate.year=date.year;
        _pickDate.month=date.month;
        _pickDate.weekIndex=date.weekIndex;
        _pickDate.dayWithWeekString=date.dayWithWeekString;
       
    }
    
    if (_pickDate.year==0||_pickDate.month==0) {
        _pickDate.yearWithMonthString=@"不限";
        _pickDate.weekIndex=-1;
         [_delegate selectDateWithyearWithPickDate:_pickDate];
    }
    else if ([_pickDate.yearWithMonthString isEqualToString:@"不限"])
    {
        _pickDate.weekIndex=-1;
        [_delegate selectDateWithyearWithPickDate:_pickDate];
    }
    
    else
    {
         [_delegate selectDateWithyearWithPickDate:_pickDate];
    }
    
}
@end
