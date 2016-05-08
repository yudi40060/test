//
//  UZHomeThemeCell.m
//  Uzai
//
//  Created by Uzai on 15/12/3.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeThemeCell.h"
#import "UZHomeThomeCollectionViewCell.h"
#import "UZActivity.h"
@interface UZHomeThemeCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBottomConstraints;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) void (^clickThemeIndexBlock)(NSUInteger index);
@end
@implementation UZHomeThemeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[NSBundle mainBundle] loadNibNamed:@"UZHomeThemeCell" owner:self options:nil][0];
        self.heightBottomConstraints.constant=0.5;
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.heightConstraints.constant=47*Main_Screen_Width/375;
        [self.collectionView registerNib:[UINib nibWithNibName:@"UZHomeThomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"homeThomeCollectionViewCell"];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)dataSource:(NSArray *)dataList withthemeIndexBlock:(void(^)(NSUInteger index))themeIndexBlock
{
    self.clickThemeIndexBlock=themeIndexBlock;
    if (dataList.count<2) {
        self.hidden=true;
    }
    self.dataList=[NSMutableArray arrayWithArray:dataList];
    [self.collectionView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UZHomeThomeCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"homeThomeCollectionViewCell" forIndexPath:indexPath];
    UZActivity *activty=[self.dataList objectAtIndex:indexPath.row];
    [cell dataSourceWithIndexPath:indexPath withImgUrl:activty.imgUrl];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=76*Main_Screen_Width/375;
    return CGSizeMake(Main_Screen_Width/2, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BLOCK_SAFE(self.clickThemeIndexBlock)(indexPath.row);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    self.collectionView=nil;
}
@end
