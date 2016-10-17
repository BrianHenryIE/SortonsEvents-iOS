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

// https://makeapppie.com/2014/09/09/swift-swift-using-tab-bar-controllers-in-swift/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
               
        // TODO - shouldn't be hardcoded
        let fomoId = FomoId.numberFromBundle(bundleName: "ie.sortons.events.ucd")!
        
        let listEventsWireframe = ListEventsWireframe(fomoId: fomoId)
        let listEventsView = listEventsWireframe.listEventsView!
        
        let directoryWireframe = DirectoryWireframe(fomoId: fomoId)
        let directoryView = directoryWireframe.directoryView!
        
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = UIColor.white
        
        let viewControllers = [listEventsView, directoryView]
        
        tabBarController.viewControllers = viewControllers
        window?.rootViewController = tabBarController
        window!.makeKeyAndVisible()
        
        let firstImage = UIImage(named: "ListEventsTabBarIcon")
        let secondImage = UIImage(named: "NewsTabBarIcon")
        let thirdImage = UIImage(named: "DirectoryTabBarIcon")
        
        listEventsView.tabBarItem = UITabBarItem(
            title: "Events",
            image: firstImage,
            tag: 1)
        
        
        
        directoryView.tabBarItem = UITabBarItem(
            title: "Directory",
            image: thirdImage,
            tag: 2)
        
        return true
    }
}
