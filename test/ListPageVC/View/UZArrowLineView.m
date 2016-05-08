//
//  UZArrowLineView.m
//  Uzai
//
//  Created by uzai on 15/12/24.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZArrowLineView.h"

@implementation UZArrowLineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code;
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,1);
    //设置颜色
    CGContextSetRGBStrokeColor(context,
                               1, 222/255.0, 230/255.0, 1.0);

    
    //开始绘制
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context,0, 0);
    CGContextAddLineToPoint(context,
                            0, 64);
    CGContextAddLineToPoint(context,rect.size.width, 70.5);
    CGContextAddLineToPoint(context,0, 76);
    CGContextAddLineToPoint(context,0, rect.size.height);
    //绘制完成
    CGContextStrokePath(context);
   
    /*画三角形*/
    //只要三个点就行跟画一条线方式一样，把三点连接起来
    CGContextSetRGBStrokeColor(context,1, 239/255.0, 244/255.0, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor ColorRGBWithString:@"#ffeff4"].CGColor);
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(0, 64.5);//坐标1
    sPoints[1] =CGPointMake(rect.size.width-1, 70);//坐标2
    sPoints[2] =CGPointMake(0, 75.5);//坐标3
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}

@end
