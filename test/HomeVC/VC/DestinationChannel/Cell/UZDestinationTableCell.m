//
//  UZDestinationTableCell.m
//  Uzai
//
//  Created by Uzai-macMini on 16/1/5.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import "UZDestinationTableCell.h"
#import "UZDestinationCollectionCell.h"

#define DestinationCellIdentifier @"DestinationCell"

@interface UZDestinationTableCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSInteger flag;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSCache *cache;
@end

@implementation UZDestinationTableCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47)];
        [self.contentView addSubview:topView];
        //前面标题label
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, SCREEN_WIDTH-50, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor ColorRGBWithString:@"#333333"];
        [self.contentView addSubview:_titleLabel];
        //更多按钮
        _moreButn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButn.frame=CGRectMake(SCREEN_WIDTH-50, 0, 50, 47);
        [_moreButn setTitle:@"更多" forState:UIControlStateNormal];
        _moreButn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        UIImage *moreImage = [UIImage imageNamed:@"icon_Searhmore.png"];
        [_moreButn setImage:moreImage forState:UIControlStateNormal];
        [_moreButn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20                                                                                                                                                                      , 0, 0)];
        [_moreButn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
        
        [_moreButn setTitleColor:[UIColor ColorRGBWithString:@"#999999"] forState:UIControlStateNormal];
        [_moreButn addTarget:self action:@selector(moreButnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_moreButn];
        //lineView
        //下方分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 46, SCREEN_WIDTH-20, 0.5)];
        lineView.backgroundColor = [UIColor ColorRGBWithString:@"#cccccc"];
        [self.contentView addSubview:lineView];
        
        
        _cache = [[NSCache alloc]init];

    }
    
    
    return self;
}
-(void)reload
{
    [self.hotDestinationCollection reloadData];
    self.hotDestinationCollection.frame = CGRectMake(12*KDestinationScale750, 47+12*KDestinationScale750, SCREEN_WIDTH-24*KDestinationScale750, flag*(81*KDestinationScale750+32));
}
-(void)setDataSourceWithArray:(NSArray *)dataArr withclassBlock:(clickHotDestinationIndex)destinationBlock
{
    _dataArray = [NSMutableArray arrayWithArray:dataArr];
    self.destinationIndexBlock = destinationBlock;
    flag = _dataArray.count>3?2:1;
    
    if (_hideMoreButn == YES) {
        //隐藏更多按钮
        _moreButn.hidden = YES;
    }else
    {
        _moreButn.hidden = NO;
    }
    
    //下方collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    if (!_hotDestinationCollection) {
        _hotDestinationCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(12*KDestinationScale750, 47+12*KDestinationScale750, SCREEN_WIDTH-24*KDestinationScale750, flag*(81*KDestinationScale750+32)) collectionViewLayout:flowLayout];
        [self.contentView addSubview:_hotDestinationCollection];
        [_hotDestinationCollection registerClass:[UZDestinationCollectionCell class] forCellWithReuseIdentifier:DestinationCellIdentifier];
    }else
    {
        self.hotDestinationCollection.frame = CGRectMake(12*KDestinationScale750, 47+12*KDestinationScale750, SCREEN_WIDTH-24*KDestinationScale750, flag*(81*KDestinationScale750+32));
    }
    _hotDestinationCollection.delegate = self;
    _hotDestinationCollection.dataSource = self;
    _hotDestinationCollection.scrollEnabled = NO;
    _hotDestinationCollection.bounces = NO;
    _hotDestinationCollection.backgroundColor = [UIColor whiteColor];
    
    

}
///
-(void)moreButnClicked:(id)sender
{
    BLOCK_SAFE(self.destinationIndexBlock)(100);
}
#pragma mark -
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString __unused *key = [NSString stringWithFormat:@"CollectionCell_%ld",(long)indexPath.row];
    UZDestinationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DestinationCellIdentifier forIndexPath:indexPath];
    
    
//    if (cell==nil) {
//        cell = [[UZDestinationCollectionCell alloc]init];
//    }
    if (_dataArray.count > 0) {
        UZHomeSubClass *homeSubClass = _dataArray[indexPath.row];
        [cell setDataSource:homeSubClass withImgUrl:[homeSubClass.NavPicUrl getZoomImageURLWithWidth:108*KDestinationScale750]];
    }
//    [_cache setObject:cell forKey:key];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(108*KDestinationScale750, KDestinationScale750*81+32);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BLOCK_SAFE(self.destinationIndexBlock)(indexPath.row);
}
-(void)dealloc
{
    self.titleLabel = nil;
    self.moreButn = nil;
    self.hotDestinationCollection = nil;
    self.dataArray = nil;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
