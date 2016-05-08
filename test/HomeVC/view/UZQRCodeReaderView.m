//
//  UZQRCodeReaderView.m
//  Uzai
//
//  Created by Uzai on 15/12/29.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZQRCodeReaderView.h"

@implementation UZQRCodeReaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self addOverlay];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect innerRect = CGRectInset(rect, 0, 0);
    
    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
    if (innerRect.size.width != minSize) {
        innerRect.origin.x   += (innerRect.size.width - minSize) / 2;
        innerRect.size.width = minSize;
    }
    else if (innerRect.size.height != minSize) {
        innerRect.origin.y    += (innerRect.size.height - minSize) / 2;
        innerRect.size.height = minSize;
    }
    
    CGRect offsetRect = CGRectOffset(innerRect, 0, 0);
    
    
    _overlay.path = [UIBezierPath bezierPathWithRoundedRect:offsetRect cornerRadius:1].CGPath;
}

#pragma mark - Private Methods

- (void)addOverlay
{
    self.backgroundColor=[UIColor clearColor];
    _overlay = [[CAShapeLayer alloc] init];
    _overlay.backgroundColor = [UIColor clearColor].CGColor;
    _overlay.fillColor       = [UIColor clearColor].CGColor;
    _overlay.strokeColor     = [UIColor whiteColor].CGColor;
    _overlay.lineWidth       = 1;
    //  _overlay.lineDashPattern = @[@7.0, @7.0];
    _overlay.lineDashPhase   = 0;
    
    [self.layer addSublayer:_overlay];
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, WIDTH(self)-40, 10)];
    self.imageView.image=[UIImage imageNamed:@"line"];
    [self addSubview:self.imageView];
    [self timerFired];
    
    //创建定时器
    self.timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(animation1)userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
-(void)timerFired
{
    self.imageView.hidden=false;
    [self animation1];
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _imageView.frame = CGRectMake(X(_imageView), 10+2*num, WIDTH(_imageView), HEIGHT(_imageView));
        if (2*num+10 >= self.frame.size.height-20) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _imageView.frame = CGRectMake(X(_imageView), 2*num,  WIDTH(_imageView), HEIGHT(_imageView));
        if (num < 10) {
            upOrdown = NO;
        }
    }
    
}

-(void)stopTimer
{
    self.imageView.hidden=true;
    //销毁定时器
    [self.timer  invalidate];
}

@end
