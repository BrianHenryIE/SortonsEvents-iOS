//
//  RootPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 3/28/17.
//  Copyright © 2017 Sortons. All rights reserved.
//

import Foundation
import UIKit

protocol RootPresenterOutput: class {

    func animateNotice(with viewData: Root.ViewModel.Banner)
}

struct Root {
    struct ViewModel {
        struct Banner {
            let title: String
            let containerHeight: CGFloat
            let alpha: CGFloat
        }
    }
}

class RootPresenter: RootInteractorOutput {

    weak var output: RootPresenterOutput?

    let noticeBannerParentHeightDefault: CGFloat = 66

    init(output: RootPresenterOutput) {
        self.output = output
    }

    func showOfflineNotice() {

        let offlineMessage = "No Network Connection"

        let viewData = Root.ViewModel.Banner(title: offlineMessage,
                                   containerHeight: noticeBannerParentHeightDefault,
                                             alpha: 1.0)

        DispatchQueue.main.async {
            self.output?.animateNotice(with: viewData)
        }
    }

    func showOnlineNotice() {

        let onlineMessage = "Connection Successful"

        let viewData = Root.ViewModel.Banner(title: onlineMessage,
                                   containerHeight: 0,
                                             alpha: 0)

        DispatchQueue.main.async {
            self.output?.animateNotice(with: viewData)
        }
    }
}
