//
//  UZHomeTimerCollectionViewCell.h
//  Uzai
//
//  Created by Uzai on 15/12/16.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZHomeTimerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CountdownView *timerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstaints;
@property (weak, nonatomic) IBOutlet UZBaseImageView *imageV;
-(void)dataSource:(NSDictionary *)dict timeText:(NSString *)timeText  startTime:(NSString *)startTime;
@end
