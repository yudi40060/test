//
//  TagList.h
//  Uzai
//
//  Created by jiang ziwe on 11/4/13.
//
//

#import <UIKit/UIKit.h>

@protocol TagListDelegate;
@interface TagList : UIView
{
    int totalHeight;
    NSArray* dataArr;
}

@property(nonatomic,assign)id Delegate;
- (id)initWithFrame:(CGRect)frame withArr:(NSArray*)arr;
- (int)getHigh;
@end


@protocol TagListDelegate <NSObject>

- (void)cityClickWithDic:(id)model;

@end
