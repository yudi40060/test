//
//  UZScaningWebVC.m
//  Uzai
//
//  Created by Uzai on 16/3/3.
//  Copyright © 2016年 悠哉旅游网. All rights reserved.
//

#import "UZScaningWebVC.h"
#import "IMYWebView.h"
@interface UZScaningWebVC ()<IMYWebViewDelegate>
@property (weak, nonatomic) IBOutlet IMYWebView *webView;

@end

@implementation UZScaningWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSURL *url =[NSURL URLWithString:self.infoStr];
    NSURLRequest *_request =[NSURLRequest requestWithURL:url];
    
    _webView.scalesPageToFit = YES;
    _webView.delegate=self;
    _webView.opaque = NO;
    _webView.scalesPageToFit=YES;
    _webView.backgroundColor=[UIColor whiteColor];
    
    [_webView loadRequest:_request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(IMYWebView *)webView
{
    self.title=webView.title;
}
-(BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
