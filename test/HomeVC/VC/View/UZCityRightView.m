//
//  UZCityRightView.m
//  Uzai
//
//  Created by Uzai on 16/1/15.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import "UZCityRightView.h"
@interface UZCityRightView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *rightIndexList;
@property (nonatomic,strong) void (^citySelectIndex)(NSUInteger index);
@end
@implementation UZCityRightView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
        [self addSubview:self.tableView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)datasource:(NSArray *)rightIndexlist withCitySelectIndex:(void(^)(NSUInteger index))citySelectIndex
{
    self.rightIndexList=rightIndexlist;
    self.citySelectIndex=citySelectIndex;
    [self.tableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rightIndexList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentity=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    cell.textLabel.text=self.rightIndexList[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont systemFontOfSize:10.0];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.citySelectIndex(indexPath.row);
}
@end
