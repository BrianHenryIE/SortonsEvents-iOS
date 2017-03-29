//
//  RootPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 3/28/17.
//  Copyright © 2017 Sortons. All rights reserved.
//

import Foundation

protocol RootPresenterOutput: class {

    func animateNotice(with title: String, isVisible: Bool)
}

class RootPresenter: RootInteractorOutput {

    weak var output: RootPresenterOutput?

    init(output: RootPresenterOutput?) {
        self.output = output
    }

    func showOfflineNotice() {

        let offlineMessage = "No Network Connection"

        DispatchQueue.main.async {
            self.output?.animateNotice(with: offlineMessage, isVisible: true)
        }
    }

    func showOnlineNotice() {

        let onlineMessage = "Connection Successful"

        DispatchQueue.main.async {
            self.output?.animateNotice(with: onlineMessage, isVisible: false)
        }
    }
}
