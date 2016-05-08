//
//  UZHomeImageView.m
//  Uzai
//
//  Created by Uzai on 15/12/3.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeImageView.h"

@implementation UZHomeImageView
-(instancetype)initWithFrame:(CGRect)frame withLineDiretion:(UZLineDirection)lineDirection
{
    self=[super initWithFrame:frame];
    if (self) {
     
        UIView *view=[[UIView alloc]init];
        if (lineDirection==UZLineDirectionRight) {
            view.frame=CGRectMake(self.frame.size.width-1, 8, 0.5, self.frame.size.height-16);
        }else if (lineDirection==UZLineDirectionBottom)
        {
             view.frame=CGRectMake(8, self.frame.size.height-1, self.frame.size.width-16,0.5);
        }else if (lineDirection==UZLineDirectionLeft)
        {
             view.frame=CGRectMake(1, 8, 0.5,self.frame.size.height-16);
        }
        
        //CGRectMake(frame.size.width-1, 8,0.5, rect.size.height-16)
        view.backgroundColor=RGBACOLOR(221, 221, 221, 1);
        [self addSubview:view];
    }
    return self;
}

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    //获得处理的上下文
//    CGContextRef  context = UIGraphicsGetCurrentContext();
//    //指定直线样式
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    //直线宽度
//    CGContextSetLineWidth(context,1/self.contentScaleFactor);
//    //设置颜色
//    CGContextSetRGBStrokeColor(context, 224/255.0, 224/255.0, 224/255.0, 1.0);
//    //    CGContextSetGrayStrokeColor(context, 1, 1);
//    //开始绘制
//    CGContextBeginPath(context);
//    if (self.lineDirection==UZLineDirectionRight) {
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width-1, 8);  //起点坐标
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width-1, self.frame.size.height-16);   //终点坐标
//    }else if (self.lineDirection==UZLineDirectionBottom)
//    {
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 8, self.frame.size.height-1);  //起点坐标
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),  self.frame.size.width-16, self.frame.size.height-1);   //终点坐标
//    }else if (self.lineDirection==UZLineDirectionLeft)
//    {
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 8);  //起点坐标
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 0, self.frame.size.height-16);   //终点坐标
//    }
//    //绘制完成
//    CGContextStrokePath(context);
//}


@end
