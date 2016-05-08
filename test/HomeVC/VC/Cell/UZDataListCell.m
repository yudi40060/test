//
//  UZDataListCell.m
//  UZai5.2
//
//  Created by UZAI on 14-9-15.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZDataListCell.h"
#import "UIColor+RGBString.h"
@interface UZDataListCell()
@property (nonatomic,copy) void (^buttonBlock)(NSString *);
@property (nonatomic,strong) NSArray *dataList;

@end
@implementation UZDataListCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setcontentText:(NSArray *)contentList withBlock:(void(^)(NSString *))buttonBlock
{
    CGFloat upx=0,upy=0;
    _dataList=contentList;
    _buttonBlock=buttonBlock;
    for (int i=0; i<contentList.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(upx, upy, Main_Screen_Width/2, 44)];
        [button setTitleColor:[UIColor ColorRGBWithString:@"#666666"] forState:UIControlStateNormal];
       
        button.layer.borderColor=[UIColor whiteColor].CGColor;
        button.layer.borderWidth=0.5;
        
        button.tag=i+1;
        [button setTitle:[contentList objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor ColorRGBWithString:@"#f3f3f3"];
        if ((i+1)%2==0) {
            upx=0;
            upy=upy+44;
        }
        else
        {
            upx=upx+Main_Screen_Width/2;
        }
    }
    [self setBackgroundColor:[UIColor ColorRGBWithString:@"#f3f3f3"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)rowOfHeight:(NSArray *)dataList
{
    if (dataList.count%2==0) {
        return dataList.count/2*44;
    }
    else
        return dataList.count/2*44+44;
}
-(void)ClickButton:(UIButton *)button
{
    NSUInteger tag=button.tag-1;
    NSString *message=[_dataList objectAtIndex:tag];
    BLOCK_SAFE(_buttonBlock)(message);
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//    if (!isIOS8Above) {
//        return;
//    }
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    float width=1.0/self.contentScaleFactor;
//    
//    
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    
//    //首先画一条竖线
//    CGContextFillRect(context, CGRectMake(Main_Screen_Width/2,0,width,HEIGHT(self)));
//    //    CGContextClosePath(context);
//    CGContextStrokePath(context);
//    
//    NSUInteger numOfLines=0;
//    BOOL isDivisible=YES;
//    if (_dataList.count%2==0) {
//        numOfLines=_dataList.count/2;
//        isDivisible=YES;
//    }
//    else
//    {
//        numOfLines=_dataList.count/2+1;
//        isDivisible=NO;
//    }
//    CGContextFillRect(context, CGRectMake(0, 40,Main_Screen_Width,width));
//    //    CGContextClosePath(context);
//    CGContextStrokePath(context);
//    
//    for (int i=0; i<numOfLines; i++) {
//        if (i==numOfLines-1&&!isDivisible) {
//            CGContextFillRect(context, CGRectMake(0,44*(i+1)-width,Main_Screen_Width/2,width));
//            //            CGContextClosePath(context);
//            CGContextStrokePath(context);
//        }
//        else
//        {
//            CGContextFillRect(context, CGRectMake(0, 44*(i+1)-width,Main_Screen_Width,width));
//            //            CGContextClosePath(context);
//            CGContextStrokePath(context);
//        }
//    }
}

@end
