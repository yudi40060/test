//
//  UZTableView.m
//  Uzai
//
//  Created by UZAI on 14-8-27.
//
//

#import "UZTableView.h"

@implementation UZTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.tableView];
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.tableViewIndex = [[UZTbaleViewIndex alloc] initWithFrame:(CGRect){Main_Screen_Width-28,0,28,frame.size.height}];
        [self addSubview:self.tableViewIndex];
        //选中索引时索引出现在屏幕中央
        self.flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(self.bounds.size.width - 64 ) / 2,(self.bounds.size.height - 64) / 2,64,64}];
        self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
        self.flotageLabel.hidden = YES;
        self.flotageLabel.textAlignment = NSTextAlignmentCenter;
        self.flotageLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.flotageLabel];
    }
    return self;
}

- (void)setDelegate:(id<UZTableViewDelegate>)delegate
{
    _delegate = delegate;
    self.tableView.delegate = delegate;
    self.tableView.dataSource = delegate;
    self.tableViewIndex.indexes = [self.delegate sectionIndexTitlesForABELTableView:self];
    CGRect rect = self.tableViewIndex.frame;
    rect.size.height=self.frame.size.height;
    rect.origin.y=0;
    self.tableViewIndex.frame = rect;
    
    self.tableViewIndex.tableViewIndexDelegate = self;
}

- (void)reloadData
{
    [self.tableView reloadData];
    self.tableViewIndex.indexes = [self.delegate sectionIndexTitlesForABELTableView:self];
    CGRect rect = self.tableViewIndex.frame;
    rect.size.height=self.frame.size.height;
    rect.origin.y=0;
    self.tableViewIndex.frame = rect;
    self.tableViewIndex.tableViewIndexDelegate = self;
}


#pragma mark -
- (void)tableViewIndex:(UZTbaleViewIndex *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title
{
    if ([self.tableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
        NSString *textString;
        if ([title length]>2) {
            textString =[textString substringToIndex:2];
        }
        else
            textString=title;
        self.flotageLabel.text = textString;
    }
}

- (void)tableViewIndexTouchesBegan:(UZTbaleViewIndex *)tableViewIndex
{
    self.flotageLabel.hidden = NO;
}

- (void)tableViewIndexTouchesEnd:(UZTbaleViewIndex *)tableViewIndex
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [self.flotageLabel.layer addAnimation:animation forKey:nil];
    
    self.flotageLabel.hidden = YES;
}

- (NSArray *)tableViewIndexTitle:(UZTbaleViewIndex *)tableViewIndex
{
    return [self.delegate sectionIndexTitlesForABELTableView:self];
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
