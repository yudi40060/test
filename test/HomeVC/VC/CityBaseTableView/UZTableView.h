//
//  UZTableView.h
//  Uzai
//
//  Created by UZAI on 14-8-27.
//
//
#import "UZTbaleViewIndex.h"
#import <UIKit/UIKit.h>
@class UZTableView;


@protocol UZTableViewDelegate <UITableViewDataSource,UITableViewDelegate>

- (NSArray *)sectionIndexTitlesForABELTableView:(UZTableView *)tableView;


@end

@interface UZTableView : UIView<UZTableViewIndexDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) id<UZTableViewDelegate> delegate;
@property (nonatomic, strong) UILabel * flotageLabel;
@property (nonatomic, strong) UZTbaleViewIndex * tableViewIndex;
- (void)reloadData;
@end
