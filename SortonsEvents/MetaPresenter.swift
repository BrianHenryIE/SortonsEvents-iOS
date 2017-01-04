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
    func showErrorAlert(title: String, message: String)
}

class MetaPresenter: MetaInteractorOutput {

    let output: MetaPresenterOutput

    init(output: MetaPresenterOutput) {
        self.output = output
    }

    func showSendMailErrorAlert() {

        let title = "Cannot send mail"
        let message = "Maybe you don't have the Mail app set up. You can always send feedback to info@sortons.ie"

        output.showErrorAlert(title: title,
                            message: message)

    }

}
