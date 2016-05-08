//
//  UZHomeTimerCollectionViewCell.m
//  Uzai
//
//  Created by Uzai on 15/12/16.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeTimerCollectionViewCell.h"

@implementation UZHomeTimerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)dataSource:(NSDictionary *)dict timeText:(NSString *)timeText  startTime:(NSString *)startTime
{
    [self.imageV setImageWithUrlStr:dict[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage] withContentMode:UIViewContentModeScaleAspectFit];
    __weak UZHomeTimerCollectionViewCell *weakSelf=self;
    SeckillingState state = [self.timerView setCountDownBlock:startTime stopDate:timeText startOverBlock:^{
        weakSelf.titleLabel.text=@"秒杀进行中！";
        [weakSelf.timerView removeFromSuperview];
        weakSelf.timerView.hidden=true;
        weakSelf.bottomConstaints.constant=5;
    } stopOverBlock:^{
        weakSelf.titleLabel.text=@"已经结束!";
        weakSelf.timerView.hidden=true;
        [weakSelf.timerView removeFromSuperview];
        weakSelf.bottomConstaints.constant=5;
    }];
    if (self.timerView==nil) {
        self.titleLabel.text=@"秒杀已结束！";
        self.timerView.hidden=true;
        [self.timerView removeFromSuperview];
        self.bottomConstaints.constant=5;
    }else
    {
        if (state==notStart) {
            self.titleLabel.text=@"距开始时间还剩:";
            self.timerView.hidden=false;
            self.bottomConstaints.constant=46;
        }else if (state==didStart)
        {
            self.titleLabel.text=@"秒杀进行中！";
            [self.timerView removeFromSuperview];
            self.timerView.hidden=true;
            self.bottomConstaints.constant=5;
        }else if(state==didStop)
        {
            self.titleLabel.text=@"秒杀已结束！";
            self.timerView.hidden=true;
            [self.timerView removeFromSuperview];
            self.bottomConstaints.constant=5;
        }
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//    if (isIOS8Above==false) {
//        self.backgroundColor=[UIColor clearColor];
//    }
//    //    //获得处理的上下文
//    CGContextRef  context = UIGraphicsGetCurrentContext();
//    //指定直线样式
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    //直线宽度
//    CGContextSetLineWidth(context,0.5);
//    //设置颜色
//    CGContextSetRGBStrokeColor(context, 224/255.0, 224/255.0, 224/255.0, 1.0);
//    //    CGContextSetGrayStrokeColor(context, 1, 1);
//    //开始绘制
//    CGContextBeginPath(context);
//    //画笔移动到点
//    CGContextMoveToPoint(context,rect.size.width-1, 8);
//    //下一点
//    CGContextAddLineToPoint(context,rect.size.width-1, rect.size.height-16);
//    //绘制完成
//    CGContextStrokePath(context);
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(rect.size.width-1, 8,0.5, rect.size.height-16)];
    view.backgroundColor=RGBACOLOR(224, 224, 224, 1);
    [self.contentView addSubview:view];
    
}
@end
