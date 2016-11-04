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
    
    init(window: UIWindow, fomoId: String) {
        
        let listEventsWireframe = ListEventsWireframe(fomoId: fomoId)
        listEventsWireframe.rootViewController = self
        let listEventsView = listEventsWireframe.listEventsView!
        
        let newsWireframe = NewsWireframe(fomoId: fomoId)
        newsWireframe.rootViewController = self
        let newsView = newsWireframe.newsView!
        
        let directoryWireframe = DirectoryWireframe(fomoId: fomoId)
        directoryWireframe.rootViewController = self
        let directoryView = directoryWireframe.directoryView!
        
        
        tabBarController.view.backgroundColor = UIColor.white
        
        let viewControllers = [listEventsView, newsView, directoryView]
        
        tabBarController.viewControllers = viewControllers
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        let firstImage = UIImage(named: "ListEventsTabBarIcon")
        let secondImage = UIImage(named: "NewsTabBarIcon")
        let thirdImage = UIImage(named: "DirectoryTabBarIcon")
        
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
        
    }
    
    func changeToNextTabLeft() {
        if(tabBarController.selectedIndex > 0) {
            tabBarController.selectedIndex = tabBarController.selectedIndex - 1
        }
    }
    
    func changeToNextTabRight() {
        if(tabBarController.selectedIndex < (tabBarController.customizableViewControllers?.count)! - 1 ) {
            tabBarController.selectedIndex = tabBarController.selectedIndex + 1
        }
    }
}
