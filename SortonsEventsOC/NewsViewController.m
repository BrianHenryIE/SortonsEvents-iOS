//
//  NewsViewController.m
//  Belfield
//
//  Created by Brian Henry on 13/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "NewsViewController.h"
#import "CommonWebViewController.h"

@interface NewsViewController () <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Code for local file which has a Facebook bug stopping progress!
//    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"html"];
//    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    // Code for displaying a remote page
    // http://sortonsevents.appspot.com/recentposts/?page_id=197528567092983
    // some data: http://www.sortons.ie/events/somerecent.html
    // http://sortonsevents.appspot.com/recentpostsmobile/news.html
    //load url into webview
    NSString *strURL = @"http://sortonsevents.appspot.com/recentpostsmobile/news.html";
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
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
//*/
//
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

    // Get the URL clicked and display it in a modal webview.
    // Maybe the webview should be a singleton?!
    if (navigationType == UIWebViewNavigationTypeLinkClicked){

        NSURL *url = [request URL];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"CommonWebViewController"];

        CommonWebViewController *cwvs = [CommonWebViewController alloc];
        cwvs = (CommonWebViewController *) myController;
        
        [cwvs setWebViewURL:url];
        
        self.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [self presentViewController:myController animated:YES completion:NULL];
        
        return NO;
    }
    
    return YES;
}

@end
