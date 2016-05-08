//
//  UZHomeWhereGoCell.h
//  Uzai
//
//  Created by Uzai on 15/12/4.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZHomeClass.h"
@interface UZHomeWhereGoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UZBaseImageView *imgView;
-(void)datasource:(UZHomeSubClass *)homeClass;
@end
