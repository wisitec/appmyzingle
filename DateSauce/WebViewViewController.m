//
//  WebViewViewController.m
//  DateSauce
//
//  Created by veena on 6/7/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()<UIWebViewDelegate>

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_activityIndicator setHidden:YES];
    
      self.titleLabel.text = _navTitle;
    
     self.webView.delegate = self;
     [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlToLoad]]];
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq
{
    [_activityIndicator startAnimating];
    return YES;
}

- (void)webViewDidFinishLoading:(UIWebView *)wv
{
    [_activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
