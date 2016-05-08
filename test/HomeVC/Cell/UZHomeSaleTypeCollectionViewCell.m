//
//  UZHomeSaleTypeCollectionViewCell.m
//  Uzai
//
//  Created by Uzai on 15/12/16.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeSaleTypeCollectionViewCell.h"
#import "UZHomeImageView.h"

@implementation UZHomeSaleTypeCollectionViewCell
-(void)dataSource:(NSArray *)dataList isEqualTotalCount:(BOOL)isEqualCount withSelectIndex:(void (^)(NSUInteger))selectImageIndex
{
    self.translatesAutoresizingMaskIntoConstraints=YES;
    self.selectImageIndex=selectImageIndex;
    self.dataList=dataList;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (dataList.count==3) {
        NSDictionary *dic=[self.dataList objectAtIndex:0];
        if (isEqualCount) {
            ////总共只有3条数的情况
            UZHomeImageView *bgImageV1=[[UZHomeImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self)/2, HEIGHT(self)) withLineDiretion:UZLineDirectionRight];
            bgImageV1.tag=1;
            [bgImageV1 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV1];
            
           
            UZHomeImageView *bgImageV2=[[UZHomeImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2, 0, WIDTH(self)/2, HEIGHT(self)/2) withLineDiretion:UZLineDirectionBottom];
            bgImageV2.tag=2;
             dic=self.dataList[1];
            [bgImageV2 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV2];
            
            
            UZHomeImageView *bgImageV3=[[UZHomeImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2, HEIGHT(self)/2, WIDTH(self)/2, HEIGHT(self)/2)];
            bgImageV3.tag=3;
            dic=self.dataList[2];
            [bgImageV3 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV3];
        }else
        {
            //总共4条的情况
           __block UZHomeImageView *bgImageV1=[[UZHomeImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)/2) withLineDiretion:UZLineDirectionBottom];
            bgImageV1.tag=2;
            [bgImageV1 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV1];
            
            UZHomeImageView *bgImageV2=[[UZHomeImageView alloc]initWithFrame:CGRectMake(0,  HEIGHT(self)/2, WIDTH(self)/2, HEIGHT(self)/2) withLineDiretion:UZLineDirectionRight];
            bgImageV2.tag=3;
            dic=self.dataList[1];
            [bgImageV2 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV2];
            
            UZHomeImageView *bgImageV3=[[UZHomeImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2, HEIGHT(self)/2, WIDTH(self)/2, HEIGHT(self)/2)];
            bgImageV3.tag=4;
            dic=self.dataList[2];
            [bgImageV3 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV3];
        }
    }else if (dataList.count==2)
    {
          NSDictionary *dic=[self.dataList objectAtIndex:0];
        //总共只有2条数的情况
        if (isEqualCount) {
            ////总共只有2条数的情况
            UZHomeImageView *bgImageV1=[[UZHomeImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self)/2, HEIGHT(self)) withLineDiretion:UZLineDirectionRight];
            bgImageV1.tag=1;
             [bgImageV1 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV1];
            
            UZHomeImageView *bgImageV2=[[UZHomeImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2, 0, WIDTH(self)/2, HEIGHT(self))];
            bgImageV2.tag=2;
            dic=self.dataList[1];
            [bgImageV2 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV2];
        }else
        {
            ////总共只有3条数的情况
            UZHomeImageView *bgImageV1=[[UZHomeImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)/2) withLineDiretion:UZLineDirectionBottom];
            bgImageV1.tag=2;
             [bgImageV1 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV1];
            
            UZHomeImageView *bgImageV2=[[UZHomeImageView alloc]initWithFrame:CGRectMake(0, HEIGHT(self)/2, WIDTH(self), HEIGHT(self)/2)];
            bgImageV2.tag=3;
            dic=self.dataList[1];
            [bgImageV2 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV2];
        }
    }else
    {
        if (self.dataList.count) {
            ////总共只有2条数的情况
            UZHomeImageView *bgImageV1=[[UZHomeImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
            bgImageV1.tag=1;
            NSDictionary *dic=[self.dataList objectAtIndex:0];
            [bgImageV1 setImageWithUrlStr:dic[@"ImageURL"] placeholderImage:[[UIColor whiteColor] colorTransformToImage]];
            [self.contentView addSubview:bgImageV1];
        }
    }
    
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UZBaseImageView class]]) {
            subView.userInteractionEnabled=true;
            [subView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
        }
    }

}
-(void)tapImageView:(UITapGestureRecognizer *)tap
{
    BLOCK_SAFE(self.selectImageIndex)(tap.view.tag);
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
}
@end
