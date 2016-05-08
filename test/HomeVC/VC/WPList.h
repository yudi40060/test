//
//  WPList.h
//  UZai5.2
//
//  Created by Uzai-macMini on 15/10/30.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassValueDelegate <NSObject>
//选中行传值给搜索框进行搜索
- (void)passValue:(NSString *)value;
//
- (void)searchKeyListScroll;
@end

@interface WPList : UITableViewController{
    NSMutableArray *currentDataArr;
}

@property (nonatomic, weak) id <PassValueDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *resultArr;

- (void)updateData;
@end
