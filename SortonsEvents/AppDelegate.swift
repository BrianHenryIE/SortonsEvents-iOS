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
    var rootInteractor: RootInteractor?

    func application(_ application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)

        guard let window = window else {
            return false
        }
        window.screen = UIScreen.main

        let storyboard = UIStoryboard(name: "Common", bundle: Bundle.main)

        let rootViewController: UIViewController

        if let fomoId = FomoId(),
            let pagingViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController")
                as? RootViewController,
            let listEventsViewController = ListEventsWireframe(fomoId: fomoId).listEventsView,
            let newsViewController = NewsWireframe(fomoId: fomoId).newsView,
            let directoryViewController = DirectoryWireframe(fomoId: fomoId).directoryView,
            let metaViewController = MetaWireframe(fomoId: fomoId).metaMainView {

            let vcs = [listEventsViewController,
                       newsViewController,
                       directoryViewController,
                       metaViewController]

            pagingViewController.viewControllers = vcs

            rootViewController = pagingViewController as UIViewController

            let rootPresenter = RootPresenter(output: rootViewController as? RootPresenterOutput)
            rootInteractor = RootInteractor(output: rootPresenter)

        } else {

            rootViewController = storyboard.instantiateViewController(withIdentifier: "MissingFomoConfig")
        }

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        Fabric.with([Crashlytics.self])

        return true
    }
}
