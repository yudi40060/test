//
//  PickerDate.h
//  Uzai
//
//  Created by UZAI on 14-7-14.
//
//

#import <Foundation/Foundation.h>

@interface PickerDate : NSObject
@property (nonatomic,assign) NSUInteger year;
@property (nonatomic,assign) NSUInteger month;
@property (nonatomic,strong) NSString *yearWithMonthString;
@property (nonatomic,assign) NSUInteger day;
@property (nonatomic,assign) NSUInteger weekIndex;
@property (nonatomic,strong) NSString *dayWithWeekString;
@end
