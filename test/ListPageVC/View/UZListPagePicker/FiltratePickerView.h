//
//  FiltratePickerView.h
//  Uzai    
//
//  Created by UZAI on 14-7-14.
//
//

#import <UIKit/UIKit.h>
#import "PickerDate.h"
@protocol SelectDateDelegate <NSObject>

-(void)selectDateWithyearWithPickDate:(PickerDate *)pickerDate;

@end
@interface FiltratePickerView : UIView
@property (nonatomic,assign) id<SelectDateDelegate> delegate;
@property (nonatomic, strong)  NSDate * date;
-(id)initWithDateStr:(NSString *)dateStr andRect:(CGRect)rect;
-(void)reloadWithDateStr:(NSString *)dateStr;
@end
