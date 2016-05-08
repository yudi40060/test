//
//  UZHomeSaleCell.m
//  Uzai
//
//  Created by Uzai on 15/12/3.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeSaleCell.h"
#import "UZHomeTimerCollectionViewCell.h"
#import "UZHomeSaleTypeCollectionViewCell.h"
@interface UZHomeSaleCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstaints;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstaints;
@property (nonatomic,strong) UZRushBuyInfo *info;
@property (nonatomic,strong) NSArray *fristDataList;
@property (nonatomic,strong) NSMutableArray *lastDataList;
@property (nonatomic,strong) void (^SaleIndexBlock)(NSUInteger index);
@end
@implementation UZHomeSaleCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"UZHomeSaleCell" owner:self options:nil][0];
        if (isIOS8Above==false) {
            self.backgroundColor=[UIColor clearColor];
            self.bottomViewHeightConstaints.constant=0.5;
        }else
        {
           self.bottomViewHeightConstaints.constant=0.5;
        }
        self.titleConstaints.constant=47*Main_Screen_Width/375;
        [self.collectionView registerNib:[UINib nibWithNibName:@"UZHomeTimerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"homeTimerCollectionViewCell"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"UZHomeSaleTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"homeSaleTypeCollectionViewCell"];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)datasource:(UZRushBuyInfo *)info withSaleIndexBlock:(void(^)(NSUInteger index))saleIndexBlock
{
    self.SaleIndexBlock=saleIndexBlock;
    self.info=info;
    self.lastDataList=[[NSMutableArray alloc]init];
    NSArray *tmhList = [NSKeyedUnarchiver unarchiveObjectWithData:self.info.tmhDatas];
    if ([self.info.tmhType integerValue]==1||[self.info.tmhType integerValue]==2) {
        
        self.fristDataList=[NSArray arrayWithObject:[tmhList firstObject]];
        for (id obj in tmhList) {
            if ([obj isEqual:[tmhList firstObject]]==false) {
                [self.lastDataList addObject:obj];
            }
        }
    }else
    {
        self.fristDataList=[NSArray new];
        [self.lastDataList addObjectsFromArray:tmhList];
    }
    __weak UZHomeSaleCell *weakSelf=self;
    [UZTheadCommon enqueueMainThreadPool:^{
        [weakSelf.collectionView reloadData];
    }];
}




#pragma mark  collectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.fristDataList.count==0)
    {
        return 1;
    }
    return 2;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.fristDataList.count==0) {
        __weak UZHomeSaleCell *weakSelf=self;
        UZHomeSaleTypeCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"homeSaleTypeCollectionViewCell" forIndexPath:indexPath];
        [cell dataSource:self.lastDataList isEqualTotalCount:true withSelectIndex:^(NSUInteger index) {
            BLOCK_SAFE(weakSelf.SaleIndexBlock)([[[weakSelf.lastDataList objectAtIndex:index-1-weakSelf.fristDataList.count] objectForKey:@"TmhType"] integerValue]);
        }];
        return cell;
    }else
    {
        if (indexPath.row==0) {
            UZHomeTimerCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"homeTimerCollectionViewCell" forIndexPath:indexPath];
            [cell setNeedsDisplay];
            [cell dataSource:[self.fristDataList firstObject] timeText:self.info.msTimeEnd startTime:self.info.msTime];
            return cell;
        }else
        {
            __weak UZHomeSaleCell *weakSelf=self;
            UZHomeSaleTypeCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"homeSaleTypeCollectionViewCell" forIndexPath:indexPath];
            [cell dataSource:self.lastDataList isEqualTotalCount:false withSelectIndex:^(NSUInteger index) {
                 BLOCK_SAFE(weakSelf.SaleIndexBlock)([[[weakSelf.lastDataList objectAtIndex:index-1-weakSelf.fristDataList.count] objectForKey:@"TmhType"] integerValue]);
            }];
            return cell;
        }
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.fristDataList.count==0&&indexPath.row==0) {
           return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    }else
    {
        
        return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height);
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
      if (self.fristDataList.count>0&&indexPath.row==0)
      {
          BLOCK_SAFE(self.SaleIndexBlock)([[[self.fristDataList firstObject]objectForKey:@"TmhType"] integerValue]);
      }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.collectionView.delegate=nil;
    self.collectionView=nil;
}

@end
