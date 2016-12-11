//
//  MetaPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

protocol MetaPresenterOutput {

}

class MetaPresenter: MetaInteractorOutput {

    let output: MetaPresenterOutput

    init(output: MetaPresenterOutput) {
        self.output = output
    }

    func openIosSettings() {
        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
    }

    func reviewOnAppStore(_ link: String) {
        UIApplication.shared.openURL(URL(string: link)!)
    }

}
