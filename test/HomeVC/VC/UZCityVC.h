//
//  UZCityVC.h
//  Uzai
//
//  Created by Uzai on 15/12/1.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZHomeService.h"
@interface UZCityVC : UZBaseVC
+ (void)showWithController:(UIViewController *)controller
               withService:(UZHomeService *)service
                    select:(void(^)(void))selectCityBlock
                    cancle:(void(^)(void))cancleBlock;
+ (void)selectCity:(UIViewController *)controller
       withService:(UZHomeService *)service
            select:(void(^)(UZCity *))selectCityBlock
            cancle:(void(^)(void))cancleBlock;
@end
