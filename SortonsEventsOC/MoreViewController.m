//
//  MoreViewController.m
//  Belfield
//
//  Created by Brian Henry on 21/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "MoreViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MoreViewController ()

- (IBAction)settingButton:(id)sender;


@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.readPermissions = @[@"public_profile", @"user_events", @"user_friends"];

    // FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    [self.view addSubview:loginButton];
       
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

- (IBAction)settingButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

}
@end
