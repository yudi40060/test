//
//  WPList.m
//  UZai5.2
//
//  Created by Uzai-macMini on 15/10/30.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "WPList.h"
#import <QuartzCore/QuartzCore.h>
#import "UZPoint.h"
#import "UZBottomCellView.h"
@implementation WPList
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)updateData {
    currentDataArr = [NSMutableArray array];
    currentDataArr = [NSMutableArray arrayWithArray:_resultArr];
    
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UZBottomCellView *lineView = [[UZBottomCellView alloc]initWithFrame:CGRectMake(0, HEIGHT(cell.contentView)-1, WIDTH(cell.contentView), 1)];
    [cell.contentView addSubview:lineView];
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    
    UZPoint *point = [currentDataArr objectAtIndex:row];
    cell.textLabel.text = point.KeyWord;
    
    return cell;
}
#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"当前选择的行:%@",currentDataArr[indexPath.row]);
    
    if ([delegate respondsToSelector:@selector(passValue:)]) {
        
        UZPoint *point = currentDataArr[indexPath.row];
        
        
        [delegate passValue:point.KeyWord];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([delegate respondsToSelector:@selector(searchKeyListScroll)]) {
        
        [delegate searchKeyListScroll];
    }
}
@end
