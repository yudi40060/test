//
//  UZDestinationCollectionCell.m
//  WPUzaiDemo
//
//  Created by Uzai-macMini on 15/12/2.
//  Copyright © 2015年 Uzai-macMini. All rights reserved.
//

#import "UZDestinationCollectionCell.h"

@interface UZDestinationCollectionCell ()
@end

@implementation UZDestinationCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:@"UZDestinationCollectionCell" owner:self options:nil]objectAtIndex:0];
        [self setBackgroundColor:[UIColor clearColor]];
        self.destinationImg.layer.cornerRadius = 2;
        self.destinationImg.layer.masksToBounds = YES;
        //
        self.destinationImgWidth.constant = 108*KDestinationScale750;
//        self.destinationImgHeight.constant = 81*KDestinationScale750;
    }
    return self;
}
-(void)setDataSource:(UZHomeSubClass *)homeSubClass withImgUrl:(NSString *)imageUrl
{
    self.destinationLabel.text = homeSubClass.NavLinkName;
    [self.destinationImg setImageWithUrlStr:imageUrl withplaceholder:nil];
}
@end
