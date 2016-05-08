//
//  UZHomeCategoryCell.m
//  Uzai
//
//  Created by Uzai on 15/12/2.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeCategoryCell.h"
#import "UZHomeMenuClass.h"
#import "UZHomeCategoryCollectionViewCell.h"
@interface UZHomeCategoryCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *homeCategoryCollectionView;
@property (nonatomic,strong) NSArray *menuList;
@end
@implementation UZHomeCategoryCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[NSBundle mainBundle] loadNibNamed:@"UZHomeCategoryCell" owner:self options:nil][0];
        self.homeCategoryCollectionView.delegate=self;
        self.homeCategoryCollectionView.dataSource=self;
        [self.homeCategoryCollectionView registerNib:[UINib nibWithNibName:@"UZHomeCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UZHomeCategoryCollectionViewCell"];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)dataSource:(NSArray *)mentList cateGoryBlock:(void(^)(NSUInteger index))categroyBlock
{
    self.menuList=mentList;
    self.homeCategoryBlockIndex=categroyBlock;
    [self.homeCategoryCollectionView reloadData];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UZHomeMenuClass *homeClass=self.menuList[indexPath.row];
    UZHomeCategoryCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"UZHomeCategoryCollectionViewCell" forIndexPath:indexPath];
    [cell.imgView setImageWithUrlStr:[homeClass.imageURL getZoomImageURLWithWidth:WIDTH(cell)] placeholderImage:[[UIColor whiteColor] colorTransformToImage] withContentMode:UIViewContentModeScaleAspectFit];
    if (indexPath.row==self.menuList.count-1) {
        cell.isLastCell=true;
    }else
    {
        cell.isLastCell=false;
    }
    [cell setNeedsDisplay];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return  CGSizeMake(WIDTH(collectionView)/self.menuList.count, 74*Main_Screen_Width/375);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BLOCK_SAFE(self.homeCategoryBlockIndex)(indexPath.row);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
