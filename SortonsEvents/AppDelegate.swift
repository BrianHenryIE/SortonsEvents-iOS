//
//  AppDelegate.swift
//  SortonsEvents
//
//  Created by Brian Henry on 12/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

//    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
//
//    // Set the application defaults
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"YES"
//    forKey:@"launch_native_apps_toggle"];
//    [defaults registerDefaults:appDefaults];
//    [defaults synchronize];

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)

        let fomoId = FomoId()

        _ = RootViewController(window: window!, fomoId: fomoId)

        return true
    }
}
