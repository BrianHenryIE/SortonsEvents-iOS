//
//  RootViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 02/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: RootViewControllerProtocol {

    let tabBarController = UITabBarController()

    init(window: UIWindow, fomoId: FomoId) {
        let listEventsWireframe = ListEventsWireframe(fomoId: fomoId)
        listEventsWireframe.rootViewController = self
        let listEventsView = listEventsWireframe.listEventsView!

        let newsWireframe = NewsWireframe(fomoId: fomoId)
        newsWireframe.rootViewController = self
        let newsView = newsWireframe.newsView!

        // Preload the webview
        _ = newsView.view

        let directoryWireframe = DirectoryWireframe(fomoId: fomoId)
        directoryWireframe.rootViewController = self
        let directoryView = directoryWireframe.directoryView!

        let metaWireframe = MetaWireframe(fomoId: fomoId)
        metaWireframe.rootViewController = self
        let metaView = metaWireframe.metaView!

        tabBarController.view.backgroundColor = UIColor.white

        let viewControllers = [listEventsView, newsView, directoryView, metaView]

        tabBarController.viewControllers = viewControllers
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        let firstImage = UIImage(named: "ListEventsTabBarIcon")
        let secondImage = UIImage(named: "NewsTabBarIcon")
        let thirdImage = UIImage(named: "DirectoryTabBarIcon")
        let metaImage = UIImage(named: "MetaTabBarIcon")

        listEventsView.tabBarItem = UITabBarItem(
            title: "Events",
            image: firstImage,
            tag: 1)

        newsView.tabBarItem = UITabBarItem(
            title: "News",
            image: secondImage,
            tag: 2)

        directoryView.tabBarItem = UITabBarItem(
            title: "Directory",
            image: thirdImage,
            tag: 3)

        metaView.tabBarItem = UITabBarItem(
            title: "About",
            image: metaImage,
            tag: 4)
    }

    func changeToNextTabLeft() {
        if tabBarController.selectedIndex > 0 {
            tabBarController.selectedIndex -= 1
        }
    }

    func changeToNextTabRight() {
        if tabBarController.selectedIndex < (tabBarController.customizableViewControllers?.count)! - 1 {
            tabBarController.selectedIndex += 1
        }
    }
}
