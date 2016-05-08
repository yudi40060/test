//
//  UZQRCodeReaderView.h
//  Uzai
//
//  Created by Uzai on 15/12/29.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZQRCodeReaderView : UIView
{
    NSUInteger num;
    BOOL upOrdown;
}
@property (nonatomic, strong) CAShapeLayer *overlay;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong)  UIImageView *imageView;
-(void)stopTimer;
-(void)timerFired;//重新开始扫描
@end
