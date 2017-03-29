//
//  RootInteractor.swift
//  SortonsEvents
//
//  Created by Brian Henry on 3/28/17.
//  Copyright © 2017 Sortons. All rights reserved.
//

import Foundation
import ReachabilitySwift

protocol RootInteractorOutput {
    func showOfflineNotice()
    func showOnlineNotice()
}

enum SortonsNotifications {
    static let Reload = Notification.Name("sortonsReloadNotification")
}

@objc class RootInteractor: NSObject {

    let output: RootInteractorOutput

    // var for testing
    var reachability = Reachability()
    var lastOnlineDate = Date()

    init(output: RootInteractorOutput) {

        self.output = output

        super.init()

        subscribeToForgroundNotification()
        setupReachability()
    }

    func subscribeToForgroundNotification() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.willEnterForeground(notification:)),
                                                   name: NSNotification.Name.UIApplicationWillEnterForeground,
                                                 object: nil)
    }

    func willEnterForeground(notification: NSNotification!) {
        refetchData()
    }

    func setupReachability() {
        reachability?.whenReachable = { reachability in
            self.refetchData()
            self.output.showOnlineNotice()
            self.lastOnlineDate = Date()
        }

        reachability?.whenUnreachable = { reachability in
            self.output.showOfflineNotice()
        }

        try? reachability?.startNotifier()
    }

    func refetchData() {
        let now = Date()
        let timeSinceLastOpened = now.timeIntervalSince(lastOnlineDate)
        if timeSinceLastOpened > TimeInterval(15*60) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: SortonsNotifications.Reload,
                                              object: self)
            }
        }
    }
}
