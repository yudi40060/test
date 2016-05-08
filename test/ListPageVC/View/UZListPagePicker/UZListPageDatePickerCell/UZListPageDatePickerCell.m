//
//  UZListPageDatePickerCell.m
//  UZai5.2
//
//  Created by uzai on 14-9-11.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZListPageDatePickerCell.h"


@implementation UZListPageDatePickerCell
{
    NSArray *_WeekList;
}


- (void)awakeFromNib
{
    // Initialization code
    
}
-(void)drawRect:(CGRect)rect
{
    if (!_pickerView) {
        CGFloat height = 1.0/self.contentScaleFactor;
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.backgroundColor = [UIColor ColorRGBWithString:@"#FFDEE6"].CGColor;
        lineLayer.frame = CGRectMake(0,47-height, rect.size.width, height);
        [self.layer addSublayer:lineLayer];
        
        //初始化时间选择器
        _pickerView=[[FiltratePickerView alloc]initWithDateStr:self.goDateCondition andRect:CGRectMake(0, 47, rect.size.width, rect.size.height-47)];
        
        _pickerView.frame=CGRectMake(0, 47, rect.size.width, rect.size.height-47);
        _pickerView.delegate=self;
        
        [self.contentView addSubview:_pickerView];
        
        _WeekList=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",
                   nil];
        [self setTitle];
    }
}
-(void)setTitle
{
    NSString *goDateCondition=self.goDateCondition;
    self.lblTitle.text=goDateCondition.length==0?@"不限":goDateCondition;
    if ([self.lblTitle.text isEqualToString:@"不限"]) {
        self.lblTitle.textColor = [UIColor blackColor];
    }else
    {
        self.lblTitle.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
    }
}
-(void)reloadWithDateStr:(NSString *)dateStr
{
    self.goDateCondition = dateStr;
    [self setTitle];
    [self.pickerView reloadWithDateStr:self.goDateCondition];
}
-(void)ShowWithSelect:(void(^)(NSString *data))onclickBlock;
{
    _onclik=onclickBlock;
}
-(void)selectDateWithyearWithPickDate:(PickerDate *)pickerDate
{
    
    NSString *str;
    
    if (pickerDate==nil) {
        str=@"不限";
    }
    
    else if (pickerDate.weekIndex==-1) {
        str=@"不限";
    }
    else if(pickerDate.year!=0&&pickerDate.month!=0&&pickerDate.day==0)
    {
        str=[NSString stringWithFormat:@"%lu年%lu月",(unsigned long)
             pickerDate.year,(unsigned long)pickerDate.month];
    }
    else
    {
        str=[NSString stringWithFormat:@"%lu年%lu月%lu日   %@",(unsigned long)pickerDate.year,(unsigned long)pickerDate.month,(unsigned long)pickerDate.day,_WeekList[pickerDate.weekIndex]];
    }
    
    self.lblTitle.text=str;
    BLOCK_SAFE(_onclik)(str);
    self.goDateCondition=str;
    
    if ([str isEqualToString:@"不限"]) {
        self.lblTitle.textColor = [UIColor blackColor];
    }else
    {
        self.lblTitle.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
