//
//  TagList.m
//  Uzai
//
//  Created by jiang ziwe on 11/4/13.
//
//

#import "TagList.h"
#import "UZVisCountry.h"

@implementation TagList
@synthesize Delegate;
- (id)initWithFrame:(CGRect)frame withArr:(NSArray*)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dataArr = [[NSArray alloc]initWithArray:arr];
        
        totalHeight = 0;
        BOOL gotPreviousFrame = NO;
        CGRect previousFrame = CGRectZero;
        for (int i = 0;i <[arr count];i++) {
            @autoreleasepool {
                UZVisCountry *country=[arr objectAtIndex:i];
                NSString* text = country.CountryName;
                
                CGSize textSize=[text sizeofWithFont:[UIFont systemFontOfSize:14]  size:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
                
                textSize.width += 30;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = frame;
                
                [button setTitle:text forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
                
                [button addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i+10;
                
                [button setExclusiveTouch:YES];
                button.backgroundColor=[[UIColor alloc]initWithWhite:0.95 alpha:1.0];
                button.layer.borderWidth=1.0f;
                button.layer.borderColor = [[UIColor alloc]initWithWhite:0.85 alpha:1.0].CGColor;
                
                if (!gotPreviousFrame) {
                    button.frame = CGRectMake(10, 0, textSize.width, 32);
                    totalHeight = 32;
                }
                else
                {
                    CGRect newRect = CGRectZero;
                    if (previousFrame.origin.x + previousFrame.size.width + textSize.width +10 > self.frame.size.width)
                    {
                        newRect.origin = CGPointMake(10, previousFrame.origin.y + 32+10 );
                        totalHeight += 32 +10;
                    }
                    else
                    {
                        newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + 10, previousFrame.origin.y);
                    }
                    newRect.size = CGSizeMake(textSize.width, 32);
                    button .frame = newRect;
                }
                previousFrame = button.frame;
                gotPreviousFrame = YES;
                
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [self addSubview:button];
            }
        }
    }
    return self;
}

- (void)cityClick:(UIButton*)_btn
{
    if (self.Delegate && [self.Delegate respondsToSelector:@selector(cityClickWithDic:)]) {
        [self.Delegate cityClickWithDic:[dataArr objectAtIndex:_btn.tag - 10]];
    }
}

- (int)getHigh
{
    return totalHeight;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
