//
//  UZHomeProductCell.h
//  Uzai
//
//  Created by Uzai on 15/12/4.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UZHomeProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UZBaseImageView *imgView;

-(void)dataSource:(UZProduct *)product;
@end
