//
//  UZTbaleViewIndex.h
//  Uzai
//
//  Created by UZAI on 14-8-27.
//
//

#import <UIKit/UIKit.h>
@protocol UZTableViewIndexDelegate;


@interface UZTbaleViewIndex : UIView
@property (nonatomic, strong) NSArray *indexes;
@property (nonatomic, weak) id <UZTableViewIndexDelegate> tableViewIndexDelegate;
@property (nonatomic,assign) CGRect tvFrame;
@end


@protocol UZTableViewIndexDelegate <NSObject>

/**
 *  触摸到索引时触发
 *
 *  @param tableViewIndex 触发didSelectSectionAtIndex对象
 *  @param index          索引下标
 *  @param title          索引文字
 */
- (void)tableViewIndex:(UZTbaleViewIndex *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title;

/**
 *  开始触摸索引
 *
 *  @param tableViewIndex 触发tableViewIndexTouchesBegan对象
 */
- (void)tableViewIndexTouchesBegan:(UZTbaleViewIndex *)tableViewIndex;
/**
 *  触摸索引结束
 *
 *  @param tableViewIndex
 */
- (void)tableViewIndexTouchesEnd:(UZTbaleViewIndex *)tableViewIndex;

/**
 *  TableView中右边右边索引title
 *
 *  @param tableViewIndex 触发tableViewIndexTitle对象
 *
 *  @return 索引title数组
 */
- (NSArray *)tableViewIndexTitle:(UZTbaleViewIndex *)tableViewIndex;

@end
