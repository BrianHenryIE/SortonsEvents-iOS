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
    
    // Code for displaying a remote page
    // http://sortonsevents.appspot.com/recentposts/?page_id=197528567092983
    // some data: http://www.sortons.ie/events/somerecent.html
    // http://sortonsevents.appspot.com/recentpostsmobile/news.html
    // http://172.20.10.2/~brianhenry/SortonsEvents-Gwt-AppEngine-Java/src/main/webapp/recentpostsmobile/news.html
    //load url into webview

     NSString *strURL = @"http://sortonsevents.appspot.com/recentpostsmobile/news.html#197528567092983";
    //NSString *strURL = @"http://172.20.10.2/~brianhenry/SortonsEvents-Gwt-AppEngine-Java/src/main/webapp/recentpostsmobile/news.html#197528567092983";
   
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.webView stringByEvaluatingJavaScriptFromString:@"refreshXfbml()"];

    NSLog(@"viewDidAppear");
}




// When the phone is rotated
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (self.view.superview){
        // Do view manipulation here.
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
        [self.webView stringByEvaluatingJavaScriptFromString:@"refreshXfbml()"];

        NSLog(@"view rotated");
    }
    
}


@end
