//
//  UIPlaceHolderTextView.h
//  Uzai
//
//  Created by jiang ziwe on 6/10/11.
//  Copyright 2011 UZAI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIPlaceHolderTextView : UITextView<UITextViewDelegate> {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

//@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
