//
//  UZHomeHeadView.h
//  UZai5.2
//
//  Created by uzai on 15/6/3.
//  Copyright (c) 2015年 xiaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZHomeHeadView : UIView
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic,copy) void (^SelectIndexBlock)(NSUInteger index);
@property (weak, nonatomic) IBOutlet UILabel *promptTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeScaningImgV;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation;

- (IBAction)onclick:(id)sender;
-(void)setCityNameWithStr:(NSString *)city;
-(void)setNormalState;
-(void)setOffsetState;
@end
