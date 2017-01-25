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

    var scrollView: UIScrollView?

    var tabBar: UITabBar?
    var viewControllers: [UIViewController]?

    var newsView: NewsViewController?
    var listEventsView: ListEventsTableViewController?

    var metaWireframe: MetaWireframe?

    var lastOpenedDate = Date()

    convenience init(fomoId: FomoId) {
        let listEventsWireframe = ListEventsWireframe(fomoId: fomoId)
        let newsWireframe = NewsWireframe(fomoId: fomoId)
        let directoryWireframe = DirectoryWireframe(fomoId: fomoId)
        let metaWireframe = MetaWireframe(fomoId: fomoId)

        let listEventsView = listEventsWireframe.listEventsView
        let newsView = newsWireframe.newsView
        let directoryView = directoryWireframe.directoryView
        let metaView = metaWireframe.metaMainView

        let vcs = [listEventsView, newsView, directoryView, metaView].flatMap({$0})

        self.init(controllers: vcs, showPageControl: true)

        metaWireframe.rootViewController = self

        self.listEventsView = listEventsView
        self.newsView = newsView

        viewControllers = vcs

        let firstImage = UIImage(named: "ListEventsTabBarIcon") ?? UIImage()
        let secondImage = UIImage(named: "NewsTabBarIcon") ?? UIImage()
        let thirdImage = UIImage(named: "DirectoryTabBarIcon") ?? UIImage()
        let metaImage = UIImage(named: "MetaTabBarIcon") ?? UIImage()

        let firstImageFilled = UIImage(named: "ListEventsTabBarIconFilled") ?? UIImage()
        let secondImageFilled = UIImage(named: "NewsTabBarIconFilled") ?? UIImage()
        let thirdImageFilled = UIImage(named: "DirectoryTabBarIconFilled") ?? UIImage()
        let metaImageFilled = UIImage(named: "MetaTabBarIconFilled") ?? UIImage()

        let firstTabBarItem = UITabBarItem(title: "Events",
                                           image: firstImage,
                                   selectedImage: firstImageFilled)
        firstTabBarItem.tag = 0
        let secondTabBarItem = UITabBarItem(title: "News",
                                            image: secondImage,
                                    selectedImage: secondImageFilled)
        secondTabBarItem.tag = 1
        let thirdTabBarItem = UITabBarItem(title: "Directory",
                                           image: thirdImage,
                                   selectedImage: thirdImageFilled)
        thirdTabBarItem.tag = 2
        let fourthTabBarItem = UITabBarItem(title: "About",
                                            image: metaImage,
                                    selectedImage: metaImageFilled)
        fourthTabBarItem.tag = 3

        tabBar = UITabBar(frame: CGRect(x: 0,
                                        y: self.view.bounds.height - 49,
                                    width: self.view.bounds.width,
                                   height: 49))

        tabBar?.items = [firstTabBarItem, secondTabBarItem, thirdTabBarItem, fourthTabBarItem]

        if let uwTabBar = tabBar {
            view.insertSubview(uwTabBar, at: 10)
        }

        loadViewIfNeeded()

        tabBar?.delegate = self

        // The first tab isn't highlighted naturally
        tabBar?.selectedItem = self.tabBar?.items?[0]

        didChangedPage = {(_ currentPage: Int)-> () in
            self.tabBar?.selectedItem = self.tabBar?
                .items?[currentPage]
        }

        for eachView in view.subviews {
            if let theView = eachView as? UIScrollView {
                scrollView = theView
            }
        }

        NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.willEnterForeground(notification:)),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                             object: nil)
    }

    func setupTabBar() {

    }

    func willEnterForeground(notification: NSNotification!) {
        let now = Date()
        let timeSinceLastOpened = now.timeIntervalSince(lastOpenedDate)
        if timeSinceLastOpened > TimeInterval(15*60) {
            newsView?.fetchNews()
            listEventsView?.fetchEventsOnLoad()
        }
        lastOpenedDate = now
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let margins = view.layoutMarginsGuide

        tabBar?.heightAnchor.constraint(equalToConstant: 49).isActive = true
        tabBar?.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        tabBar?.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        tabBar?.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true

    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            if self.scrollView?.subviews.count ?? 0 > 0 {

                self.scrollView?.frame = CGRect(x: 0,
                                               y: 0,
                                               width: size.width,
                                               height: size.height)

                let scrollviewWidth = size.width * CGFloat(self.scrollView?.subviews.count ?? 1)

                self.scrollView?.contentSize = CGSize(width: scrollviewWidth,
                                                     height: size.height)

                var i: Int = 0
                self.scrollView?.subviews.forEach({
                    $0.frame = CGRect(x: size.width * CGFloat(i),
                                      y: 0,
                                  width: size.width,
                                 height: size.height)
                    i += 1
                })

                let xOffset = CGFloat(self.tabBar?.selectedItem?.tag ?? 0) * size.width
                self.scrollView?.setContentOffset(CGPoint(x: xOffset,
                                                         y: self.scrollView?.contentOffset.y ?? 0),
                                                  animated: false)
            }
                self.tabBar?.frame = CGRect(x: 0,
                                           y: size.height - 49,
                                       width: size.width,
                                      height: 49)
        }, completion: { _ in
            self.setCurrentIndex(self.tabBar?.selectedItem?.tag ?? 0, animated: true)
        })

        viewControllers?.forEach({
            $0.viewWillTransition(to: size,
                                with: coordinator)
        })

    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setCurrentIndex(item.tag, animated: true)
    }
}
