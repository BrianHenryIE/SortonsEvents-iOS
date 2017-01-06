//
//  RootViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 02/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import UIKit
import SLPagingViewSwift_Swift3

class RootViewController: SLPagingViewSwift, UITabBarDelegate {

    var tabBar: UITabBar!
    var viewControllers: [UIViewController]!

    var metaWireframe: MetaWireframe!

    convenience init(fomoId: FomoId) {
        let listEventsWireframe = ListEventsWireframe(fomoId: fomoId)
        let listEventsView = listEventsWireframe.listEventsView!

        let newsWireframe = NewsWireframe(fomoId: fomoId)
        let newsView = newsWireframe.newsView!

        let directoryWireframe = DirectoryWireframe(fomoId: fomoId)
        let directoryView = directoryWireframe.directoryView!

        let metaWireframe = MetaWireframe(fomoId: fomoId)
        let metaView = metaWireframe.metaView!

        let vcs = [listEventsView, newsView, directoryView, metaView]

        self.init(controllers: vcs, showPageControl: true)

        self.metaWireframe = metaWireframe

        let firstImage = UIImage(named: "ListEventsTabBarIcon")!
        let secondImage = UIImage(named: "NewsTabBarIcon")!
        let thirdImage = UIImage(named: "DirectoryTabBarIcon")!
        let metaImage = UIImage(named: "MetaTabBarIcon")!

        let firstImageFilled = UIImage(named: "ListEventsTabBarIconFilled")!
        let secondImageFilled = UIImage(named: "NewsTabBarIconFilled")!
        let thirdImageFilled = UIImage(named: "DirectoryTabBarIconFilled")!
        let metaImageFilled = UIImage(named: "MetaTabBarIconFilled")!

        let firstTabBarItem = UITabBarItem(title: "Events", image: firstImage, selectedImage: firstImageFilled)
        firstTabBarItem.tag = 0
        let secondTabBarItem = UITabBarItem(title: "News", image: secondImage, selectedImage: secondImageFilled)
        secondTabBarItem.tag = 1
        let thirdTabBarItem = UITabBarItem(title: "Directory", image: thirdImage, selectedImage: thirdImageFilled)
        thirdTabBarItem.tag = 2
        let fourthTabBarItem = UITabBarItem(title: "About", image: metaImage, selectedImage: metaImageFilled)
        fourthTabBarItem.tag = 3

        tabBar = UITabBar(frame: CGRect(x: 0,
                                        y: self.view.bounds.height - 49,
                                        width: self.view.bounds.width,
                                        height: 49))

        tabBar.items = [firstTabBarItem, secondTabBarItem, thirdTabBarItem, fourthTabBarItem]

        self.view.insertSubview(tabBar, at: 10)

        self.loadViewIfNeeded()

        tabBar.delegate = self

        // The first tab isn't highlighted naturally
        self.tabBar.selectedItem = self.tabBar.items![0]

        self.didChangedPage = {(_ currentPage: Int)-> () in
            self.tabBar.selectedItem = self.tabBar.items![currentPage]
        }

    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setCurrentIndex(item.tag, animated: true)
    }
}
