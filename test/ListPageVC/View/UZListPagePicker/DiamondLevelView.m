//
//  DiamondLevelView.m
//  Uzai
//
//  Created by uzai on 15/12/28.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "DiamondLevelView.h"
#import "DiamondLevelCell.h"
#import "UZArrowLineView.h"

@implementation DiamondLevelView
{
    UICollectionView *myCollectionView;
    NSArray *arrayTitle;
    NSUInteger selectIndex;
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
        [myCollectionView registerNib:[UINib nibWithNibName:@"DiamondLevelCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"diamondLevelCell"];
        arrayTitle = @[@"不限",@"六钻",@"五钻",@"四钻",@"三钻"];
        selectIndex = 0;
        
        UZArrowLineView *lineView = [[UZArrowLineView alloc]initWithFrame:CGRectMake(0, 0, 6, frame.size.height)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
    }
    
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayTitle.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30, 30, 30, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 30;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w=(WIDTH(collectionView)-90)/ 2.0;
    
    return CGSizeMake(w,w/2.2);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiamondLevelCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"diamondLevelCell" forIndexPath:indexPath];
    cell.lblLevel.text = arrayTitle[indexPath.row];
    CGFloat w=(WIDTH(collectionView)-90)/ 2.0/2.2/2;
    if (indexPath.row == selectIndex) {
        ViewBorderRadius(cell.lblLevel, w, 1, [UIColor ColorRGBWithString:@"#fb84a2"]);
        cell.lblLevel.textColor = [UIColor ColorRGBWithString:@"#fb84a2"];
    }else
    {
        ViewBorderRadius(cell.lblLevel, w, 1, [UIColor ColorRGBWithString:@"#cfcfcf"]);
        cell.lblLevel.textColor = bg66Color;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = indexPath.row;
    [myCollectionView reloadData];
    self.onclik([self getLevelWithIndex:indexPath.row]);
}
-(void)selectIndex:(void (^)(NSUInteger))onclickBlock
{
    self.onclik = onclickBlock;
}
-(void)setSelectIndex:(NSUInteger)index
{
    selectIndex = [self getIndexWithDiamonLevel:index];
    [myCollectionView reloadData];
}
-(NSUInteger)getIndexWithDiamonLevel:(NSUInteger)level
{
    if (level == 0) {
        return 0;
    }else if (level == 6)
    {
        return 1;
    }else if (level == 5)
    {
        return 2;
    }else if (level == 4)
    {
        return 3;
    }else if (level == 3)
    {
        return 4;
    }
    return 0;
}
-(NSUInteger)getLevelWithIndex:(NSUInteger)index
{
    if (index == 0) {
        return 0;
    }else if (index == 1)
    {
        return 6;
    }else if (index == 2)
    {
        return 5;
    }else if (index == 3)
    {
        return 4;
    }else if (index == 4)
    {
        return 3;
    }
    return 0;
}
@end
