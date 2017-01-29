//
//  RootViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 02/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: SLPagingViewSwift, UITabBarDelegate {

    var fomoId: FomoId?

    @IBOutlet weak var tabBar: UITabBar!

    var viewControllers: [UIViewController]? {
        didSet {
            viewControllers?.forEach({
                self.addChildViewController($0)
            })

            self.setupViews(items: viewControllers!.map({ let item = UILabel()
                                                          item.text = $0.title
                                                          return item }),
                            views: viewControllers!.map({ $0.view! }),
                  showPageControl: true,
                 navBarBackground: UIColor.clear)
        }
    }

    var lastOpenedDate = Date()

    override func viewDidLoad() {

        super.viewDidLoad()

        // The first tab isn't highlighted naturally
        tabBar?.selectedItem = self.tabBar?.items?[0]

        didChangedPage = {(_ currentPage: Int)-> () in
            self.indexSelected = currentPage
            self.tabBar?.selectedItem = self.tabBar?.items?[currentPage]
        }

        NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.willEnterForeground(notification:)),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                             object: nil)
    }

    func willEnterForeground(notification: NSNotification!) {
        let now = Date()
        let timeSinceLastOpened = now.timeIntervalSince(lastOpenedDate)
        if timeSinceLastOpened > TimeInterval(15*60) {
            viewControllers?.forEach({
                ($0 as? NewsViewController)?.fetchNews()
                ($0 as? ListEventsTableViewController)?.fetchEventsOnLoad()
            })
        }
        lastOpenedDate = now
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            if self.views.count > 0 {

                self.scrollView.frame = CGRect(x: 0,
                                               y: 0,
                                           width: size.width,
                                          height: size.height)

                self.scrollView.contentSize = CGSize(width: size.width * CGFloat(self.views.count),
                                                    height: size.height)

                for (index, view) in self.views {
                    view.frame = CGRect(x: size.width * CGFloat(index),
                                        y: 0,
                                    width: size.width,
                                   height: size.height)
                }

                self.scrollView?.setContentOffset(CGPoint(x: size.width * CGFloat(self.indexSelected),
                                                          y: self.scrollView.contentOffset.y),
                                                   animated: false)
            }
        }, completion: nil)
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setCurrentIndex(item.tag, animated: true)
    }
}
