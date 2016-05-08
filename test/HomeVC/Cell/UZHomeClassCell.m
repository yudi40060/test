//
//  UZHomeClassCell.m
//  Uzai
//
//  Created by Uzai on 15/12/2.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeClassCell.h"
#import "UZHomeClassCollectionViewCell.h"
#import "UZHomeClass.h"
@interface UZHomeClassCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstaints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstaints;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *homeClassList;
//@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) CGFloat width;
@end
@implementation UZHomeClassCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[NSBundle mainBundle] loadNibNamed:@"UZHomeClassCell" owner:self options:nil][0];
        NSUInteger  remainderNum=(NSUInteger)Main_Screen_Width%5;
        self.leftConstaints.constant=remainderNum/2;
        self.rightConstaints.constant=remainderNum/2;
        self.collectionView.backgroundColor=[UIColor whiteColor];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"UZHomeClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"homeClassCollectionViewCell"];
  
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)datasourceWithData:(NSArray *)dataList
           withclassBlock:(clickClassIndex)classBlock;
{
    NSUInteger  remainderNum=(NSUInteger)Main_Screen_Width%5;
    self.width=(Main_Screen_Width-remainderNum)/5;
    self.homeClassList=dataList;
    self.classIndexBlock=classBlock;
    [self.collectionView reloadData];//刷新数据
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.homeClassList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UZHomeClass *homeClass=self.homeClassList[indexPath.row];
    UZHomeClassCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"homeClassCollectionViewCell" forIndexPath:indexPath];
    [cell datasource:homeClass.subClass.NavLinkName imgUrl:[homeClass.subClass.MobileNavIconURL getZoomImageURLWithWidth: WIDTH(cell.classImgView)]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
   return  CGSizeMake(self.width, 92*Main_Screen_Width/375);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BLOCK_SAFE(self.classIndexBlock)(indexPath.row);
}

-(void)dealloc
{
    _collectionView=nil;
    _classIndexBlock=nil;
}
@end
