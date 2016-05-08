//
//  UZHomeScaningVC.h
//  Uzai
//
//  Created by Uzai on 15/12/29.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZBaseVC.h"

@interface UZHomeScaningVC : UIViewController
+ (void)showWithController:(UIViewController *)controller
                    select:(void(^)(NSString *urlStr))scaningResults;
@end
