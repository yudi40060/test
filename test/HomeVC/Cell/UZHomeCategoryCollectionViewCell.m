//
//  UZHomeCategoryCollectionViewCell.m
//  Uzai
//
//  Created by Uzai on 16/1/20.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import "UZHomeCategoryCollectionViewCell.h"

@implementation UZHomeCategoryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

/*
 //获得处理的上下文
 CGContextRef  context = UIGraphicsGetCurrentContext();
 //指定直线样式
 CGContextSetLineCap(context, kCGLineCapSquare);
 //直线宽度
 CGContextSetLineWidth(context,1);
 //设置颜色
 CGContextSetRGBStrokeColor(context, 224/255.0, 224/255.0, 224/255.0, 1.0);
 //    CGContextSetGrayStrokeColor(context, 1, 1);
 //开始绘制
 CGContextBeginPath(context);
 //画笔移动到点
 CGContextMoveToPoint(context,self.indexPath.row==2?0:10, rect.size.height);
 //下一点
 CGContextAddLineToPoint(context,rect.size.width-(self.indexPath.row==2?0:10), rect.size.height);
 //绘制完成
 CGContextStrokePath(context);
 */
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.isLastCell==false) {
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(rect.size.width-0.5, 8,0.5, HEIGHT(self)-16);
        //CGRectMake(frame.size.width-1, 8,0.5, rect.size.height-16)
        view.backgroundColor=RGBACOLOR(221, 221, 221, 1);
        [self addSubview:view];
    }
}
@end
