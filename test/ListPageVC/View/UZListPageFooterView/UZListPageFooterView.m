//
//  UZListPageFooterView.m
//  Uzai
//
//  Created by uzai on 15/12/23.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZListPageFooterView.h"
#import "UZListPageFooterCell.h"

@implementation UZListPageFooterView
{
    UICollectionView *myCollectionView;
    NSArray *arrayTitle;
    NSArray *arrayImage;
    
    NSInteger selectIndex;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        myCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        myCollectionView.delegate = self;
        myCollectionView.dataSource = self;
        myCollectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:myCollectionView];
        [myCollectionView registerClass:[UZListPageFooterCell class] forCellWithReuseIdentifier:@"listPageFooterCell"];
        arrayTitle = @[@"目的地",@"价格",@"销量",@"筛选"];
        arrayImage = @[@"icon_listpage_destination",@"icon_listpage_price",@"icon_listpage_sales",@"icon_listpage_filter"];
        selectIndex = -1;
        self.isShowDesination = YES;
    }
    
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.isShowDesination ? arrayTitle.count : arrayTitle.count-1;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w;

    w=WIDTH(collectionView)/(self.isShowDesination ? arrayTitle.count : arrayTitle.count-1);
    
    return CGSizeMake(w,50);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UZListPageFooterCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"listPageFooterCell" forIndexPath:indexPath];
    if (self.isShowDesination) {
        cell.lblTitle.text = arrayTitle[indexPath.row];
    }else
    {
        cell.lblTitle.text = arrayTitle[indexPath.row+1];
    }
    
    
    //价格
    if ((self.isShowDesination&&indexPath.row==1)||((!self.isShowDesination)&&indexPath.row==0)) {
        
        // 1推荐热门，2价格升序，3销量降序，4推荐冷门，5价格降序，6，销售量升序）
        if (self.service.listPageModel.orderBy == 2) {
            cell.lblTitle.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
            cell.imageIcon.image = [UIImage imageNamed:@"icon_listpage_price_select2"];
        }else if(self.service.listPageModel.orderBy == 5)
        {
            cell.lblTitle.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
            cell.imageIcon.image = [UIImage imageNamed:@"icon_listpage_price_select"];
        }else
        {
            cell.lblTitle.textColor = [UIColor ColorRGBWithString:@"#666666"];
            cell.imageIcon.image = [UIImage imageNamed:@"icon_listpage_price_unselect"];
        }
    }
    //销量
    else if ((self.isShowDesination&&indexPath.row==2)||((!self.isShowDesination)&&indexPath.row==1)) {
        // 1推荐热门，2价格升序，3销量降序，4推荐冷门，5价格降序，6，销售量升序）
        if (self.service.listPageModel.orderBy == 3) {
            cell.lblTitle.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
            cell.imageIcon.image = [UIImage imageNamed:@"icon_listpage_sales_select"];
        }else
        {
            cell.lblTitle.textColor = [UIColor ColorRGBWithString:@"#666666"];
            cell.imageIcon.image = [UIImage imageNamed:@"icon_listpage_sales_unselect"];
        }
    }
    else if((self.isShowDesination&&indexPath.row==3)||((!self.isShowDesination)&&indexPath.row==2))
    {
        if (indexPath.row == selectIndex) {
            cell.imageIcon.image = [UIImage imageNamed:@"icon_listpage_filter_select"];
            cell.lblTitle.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
        }else
        {
            cell.imageIcon.image = [UIImage imageNamed:@"icon_listpage_filter_unselect"];
            cell.lblTitle.textColor = [UIColor ColorRGBWithString:@"#666666"];
        }
    }
    else
    {
        if (indexPath.row == selectIndex) {
            cell.imageIcon.image = [UIImage imageNamed:@"icon_listpage_destination_select"];
            cell.lblTitle.textColor = [UIColor ColorRGBWithString:bgWithTextColor];
        }else
        {
            cell.imageIcon.image = [UIImage imageNamed:@"icon_listpage_destination_unselect"];
            cell.lblTitle.textColor = [UIColor ColorRGBWithString:@"#666666"];
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = indexPath.row;
    
    if ((self.isShowDesination&&selectIndex==1)||((!self.isShowDesination)&&selectIndex==0)) {
        [self setOrderByWithIsPriceSort:YES];
    }
    else if ((self.isShowDesination&&selectIndex==2)||((!self.isShowDesination)&&selectIndex==1)) {
        [self setOrderByWithIsPriceSort:NO];
    }
    
    [myCollectionView reloadData];
    self.onclik(self.isShowDesination?indexPath.row:indexPath.row+1);
}
-(void)setOrderByWithIsPriceSort:(BOOL)isPriceSort
{
    // 1推荐热门，2价格升序，3销量降序，4推荐冷门，5价格降序，6，销售量升序）
    if (isPriceSort) {
        if (self.service.listPageModel.orderBy == 1 || self.service.listPageModel.orderBy == 3) {
            self.service.listPageModel.orderBy =  2;
        }else if (self.service.listPageModel.orderBy == 2)
        {
            self.service.listPageModel.orderBy = 5;
        }
        else
        {
            self.service.listPageModel.orderBy = 1;
        }
    }else
    {
        if (self.service.listPageModel.orderBy == 1 || self.service.listPageModel.orderBy == 2 || self.service.listPageModel.orderBy == 5) {
            self.service.listPageModel.orderBy =  3;
        }else
        {
            self.service.listPageModel.orderBy = 1;
        }
    }
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat height = 1.0/self.contentScaleFactor;
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.backgroundColor = [UIColor ColorRGBWithString:@"#cccccc"].CGColor;
    lineLayer.frame = CGRectMake(0,0, rect.size.width, height);
    [self.layer addSublayer:lineLayer];
}
-(void)selectIndex:(void (^)(NSInteger))onclickBlock
{
    self.onclik = onclickBlock;
}
-(void)setShowDesination:(BOOL)isShowDesination
{
    self.isShowDesination=isShowDesination;
    [myCollectionView reloadData];
}
-(void)reset
{
    selectIndex = -1;
    [myCollectionView reloadData];
}
-(void)reload
{
    [myCollectionView reloadData];
}
-(void)dealloc
{
    
}
@end
