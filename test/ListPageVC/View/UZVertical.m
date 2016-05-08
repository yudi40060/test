//
//  UZVertical.m
//  UZai5.2
//
//  Created by uzai on 14/12/12.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZVertical.h"

@implementation UZVertical


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float width=1.0/self.contentScaleFactor;
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0,0,width,rect.size.height));
    CGContextStrokePath(context);
}


@end
