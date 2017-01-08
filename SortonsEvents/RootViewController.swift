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

    var scrollView: UIScrollView!

    var tabBar: UITabBar!
    var viewControllers: [UIViewController]!

    var newsView: NewsViewController!

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

        self.newsView = newsView
        self.metaWireframe = metaWireframe
        self.viewControllers = vcs

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

        for eachView in view.subviews {
            if let theView = eachView as? UIScrollView {
                scrollView = theView
            }
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let margins = view.layoutMarginsGuide

        tabBar.heightAnchor.constraint(equalToConstant: 49).isActive = true
        tabBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        tabBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        tabBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true

    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            if self.scrollView.subviews.count > 0 {

                self.scrollView.frame = CGRect(x: 0,
                                               y: 0,
                                               width: size.width,
                                               height: size.height)

                let scrollviewWidth = size.width * CGFloat(self.scrollView.subviews.count)

                self.scrollView.contentSize = CGSize(width: scrollviewWidth,
                                                     height: size.height)

                var i: Int = 0
                for v in self.scrollView.subviews {
                    v.frame = CGRect(x: size.width * CGFloat(i),
                                     y: 0,
                                     width: size.width,
                                     height: size.height)
                    i += 1
                }

                let xOffset = CGFloat(self.tabBar.selectedItem!.tag) * size.width
                self.scrollView.setContentOffset(CGPoint(x: xOffset,
                                                         y: self.scrollView.contentOffset.y),
                                                  animated: false)
            }
                self.tabBar.frame = CGRect(x: 0,
                                           y: size.height - 49,
                                           width: size.width,
                                           height: 49)
        }, completion: { _ in
                                self.setCurrentIndex(self.tabBar.selectedItem!.tag, animated: true)

        })

        for vc in viewControllers {
            vc.viewWillTransition(to: size, with: coordinator)
        }

    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setCurrentIndex(item.tag, animated: true)
    }
}
