//
//  UZDingzhiYouVC.m
//  UZai5.2
//
//  Created by UZAI on 14-9-25.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "UZDingzhiYouVC.h"

@interface UZDingzhiYouVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UZDingzhiYouVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:self.title];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.title];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *UrlString=@"http://sijia.uzai.com";
    NSURL *url =[NSURL URLWithString:UrlString];
    NSURLRequest *_request =[NSURLRequest requestWithURL:url];
    [self.view addSubview:_webView];
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
    _webView.delegate=self;
    self.title=@"私家团";
     _webView.scalesPageToFit =YES;
    [_webView loadRequest:_request];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingWithMessage:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoading];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoading];
}
@end
