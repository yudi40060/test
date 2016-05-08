//
//  UZHomeScaningLayerView.m
//  Uzai
//
//  Created by Uzai on 20/12/30.
//  Copyright © 2020年 悠哉旅游网. All rights reserved.
//

#import "UZHomeScaningLayerView.h"

#define startX(rect) rect.origin.x
#define startY(rect)  rect.origin.y
#define deleteNumber   3
@implementation UZHomeScaningLayerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
//    self.backgroundColor=[UIColor clearColor];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置矩形填充颜色：
    CGContextSetFillColorWithColor(context, RGBACOLOR(0, 0, 0, 0.3).CGColor);
    
    CGContextFillRect(context, rect);
    CGContextClip(context);
    CGContextClearRect(context, self.contextrect);
    //执行绘画
    CGContextStrokePath(context);
    
   
    
    
    NSArray *rects=@[NSStringFromCGRect(CGRectMake(startX(self.contextrect)-deleteNumber, startY(self.contextrect)-deleteNumber, 20, 5)),
                     NSStringFromCGRect(CGRectMake(startX(self.contextrect)-deleteNumber, startY(self.contextrect)-deleteNumber, 5, 20)),
                    NSStringFromCGRect(CGRectMake(self.contextrect.size.width-20+startX(self.contextrect)+deleteNumber, startY(self.contextrect)-deleteNumber, 20, 5)),
                     NSStringFromCGRect(CGRectMake(self.contextrect.size.width-5+startX(self.contextrect)+deleteNumber, startY(self.contextrect)-deleteNumber, 5, 20)),
                     NSStringFromCGRect(CGRectMake(startX(self.contextrect)-deleteNumber, self.contextrect.size.height-20+startY(self.contextrect)+deleteNumber, 5, 20)),
                     NSStringFromCGRect(CGRectMake(startX(self.contextrect)-deleteNumber, self.contextrect.size.height-5+startY(self.contextrect)+deleteNumber, 20, 5)),
                     NSStringFromCGRect(CGRectMake(self.contextrect.size.width-20+startX(self.contextrect)+deleteNumber, self.contextrect.size.height-5+startY(self.contextrect)+deleteNumber, 20, 5)),
                     NSStringFromCGRect(CGRectMake(self.contextrect.size.width-5+startX(self.contextrect)+deleteNumber, self.contextrect.size.height-20+startY(self.contextrect)+deleteNumber, 5, 20))];
    
    //    const CGRect *newRect=(__bridge const CGRect *)(rects);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    //设置矩形填充颜色：
    //    CGContextSetFillColorWithColor(context, [UIColor ColorRGBWithString:bgWithTextColor].CGColor);
    //    CGContextFillRects(context, newRect, rects.count);
    //    //执行绘画
    //    CGContextStrokePath(context);
    
    for (NSUInteger i=0; i<rects.count; i++) {
        @autoreleasepool {
            CGRect indexRect=CGRectFromString(rects[i]);
            UIView *rectView=[[UIView alloc]initWithFrame:indexRect];
            rectView.backgroundColor=[UIColor ColorRGBWithString:bgWithTextColor];
            [self addSubview:rectView];
        }
    }
}


@end
