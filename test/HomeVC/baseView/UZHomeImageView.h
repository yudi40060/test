//
//  UZHomeImageView.h
//  Uzai
//
//  Created by Uzai on 15/12/3.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZBaseImageView.h"
typedef NS_ENUM(NSInteger, UZLineDirection) {
    UZLineDirectionLeft,
    UZLineDirectionRight,
    UZLineDirectionBottom,
    UZLineDirectionTop
};
@interface UZHomeImageView : UZBaseImageView
-(instancetype)initWithFrame:(CGRect)frame withLineDiretion:(UZLineDirection)lineDirection;
@end
