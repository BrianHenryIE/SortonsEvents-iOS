//
//  RootPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 3/28/17.
//  Copyright © 2017 Sortons. All rights reserved.
//

import Foundation

protocol RootPresenterOutput: class {

}

class RootPresenter: RootInteractorOutput {

    weak var output: RootPresenterOutput?

    init(output: RootPresenterOutput?) {
        self.output = output
    }

    func showOfflineNotice() {

    }

    func showOnlineNotice() {

    }
}
