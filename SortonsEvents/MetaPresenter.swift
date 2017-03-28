//
//  MetaPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import UIKit

protocol MetaPresenterOutputProtocol {
    func showFeedbackTypeAlert()
    func showErrorAlert(title: String, message: String)
    func share(_ objectsToShare:[Any])
    func sendFeedbackEmail(to address: String, with subject: String)
}

class MetaPresenter: MetaInteractorOutputProtocol {

    let fomoId: FomoId
    let output: MetaPresenterOutputProtocol?

    init(fomoId: FomoId,
         output: MetaPresenterOutputProtocol?) {
        self.fomoId = fomoId
        self.output = output
    }

    func share() {
        let shareText = "Check out \(fomoId.name) on the App Store"
        let url = "https://itunes.apple.com/app/id\(fomoId.appStoreId)"

        guard let appStoreLink = URL(string: url) else { return }

        let objectsToShare = [shareText, appStoreLink] as [Any]

        DispatchQueue.main.async {
            self.output?.share(objectsToShare)
        }
    }

    func showFeedbackTypeAlert() {
        DispatchQueue.main.async {
            self.output?.showFeedbackTypeAlert()
        }
    }

    func sendFeedback(for type: FeedbackType) {
        let subject: String
        switch type {
        case .complaint:
            subject = "Complaint"
        case .praise:
            subject = "Praise"
        case .suggestion:
            subject = "Suggestion"
        }

        let address = "info@sortons.ie"

        DispatchQueue.main.async {
            self.output?.sendFeedbackEmail(to: address, with: subject)
        }
    }

    func showSendMailErrorAlert() {

        let title = "Cannot send mail"
        let message = "Maybe you don't have the Mail app set up. You can always send feedback to info@sortons.ie"

        DispatchQueue.main.async {
            self.output?.showErrorAlert(title: title,
                                      message: message)
        }

    }
}
