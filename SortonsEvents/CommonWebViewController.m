//
//  CommonWebViewController.m
//  Belfield
//
//  Created by Brian Henry on 16/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "CommonWebViewController.h"

@interface CommonWebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

 - (IBAction)doneButton:(id)sender;

@property (strong, nonatomic) IBOutlet UINavigationItem *titleLabel;

@property (strong, nonatomic) NSURL *url;

@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:_url];
    [self.webView loadRequest:urlRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setWebViewURL:(NSURL *)url{
    _url = url;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    // Change the title of the webview to the current page's title.
    [_titleLabel setTitle: [webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneButton:(id)sender {

    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
