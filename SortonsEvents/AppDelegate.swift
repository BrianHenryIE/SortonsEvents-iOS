//
//  AppDelegate.swift
//  SortonsEvents
//
//  Created by Brian Henry on 12/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window!.screen = UIScreen.main

        let rvc: UIViewController
        if let fomoId = FomoId() {
            rvc = RootViewController(fomoId: fomoId)
        } else {
            let storyboard = UIStoryboard(name: "Common", bundle: Bundle.main)
            rvc = storyboard.instantiateViewController(withIdentifier: "MissingFomoConfig")
        }

        window!.rootViewController = rvc
        window!.makeKeyAndVisible()

        Fabric.with([Crashlytics.self])

        return true
    }
}
