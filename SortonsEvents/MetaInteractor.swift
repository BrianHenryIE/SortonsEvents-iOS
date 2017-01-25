//
//  MetaInteractor.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import MessageUI

protocol MetaInteractorOutputProtocol {
    func showSendMailErrorAlert()
    func showFeedbackTypeAlert()
    func sendFeedback(for type: FeedbackType)
    func share()
}

enum SettingsPage: Int {
    case about = 0, changelog, privacyPolicy
}

enum FeedbackType {
    case suggestion, praise, complaint
}

class MetaInteractor: NSObject, MetaViewControllerOutputProtocol {

    let presenter: MetaInteractorOutputProtocol

    let fomoId: FomoId
    let wireframe: MetaWireframe

    init(wireframe: MetaWireframe, fomoId: FomoId, presenter: MetaInteractorOutputProtocol) {
        self.presenter = presenter
        self.fomoId = fomoId
        self.wireframe = wireframe
    }

    func selectedCell(at indexPath: IndexPath) {

        switch indexPath.section {
        case 0:
            guard let page = SettingsPage(rawValue: indexPath.row) else {
                return
            }
            showWebView(for: page)
        case 1:
            switch indexPath.row {
            case 0:
                presenter.share()
            case 1:
                presenter.showFeedbackTypeAlert()
            case 2:
                openIosSettings()
            case 3:
                rateInAppStore()
            default:
                break
            }
        default:
            break
        }
    }

    private func showWebView(for page: SettingsPage) {
        let url: String
        switch page {
        case .about:
            url = "http://sortons.ie/events/about.html#\(fomoId.shortName)"
        case .changelog:
            url = "http://sortons.ie/events/changelog.html#\(fomoId.shortName)"
        case .privacyPolicy:
            url = "http://sortons.ie/events/privacypolicy.html#\(fomoId.shortName)"
        }
        wireframe.presentWebView(for: url)
    }

    // https://www.andrewcbancroft.com/2014/08/25/send-email-in-app-using-mfmailcomposeviewcontroller-with-swift/
    func sendFeedback(for type: FeedbackType) {
        if MFMailComposeViewController.canSendMail() {
            presenter.sendFeedback(for: type)
        } else {
            presenter.showSendMailErrorAlert()
        }
    }

    private func openIosSettings() {
        wireframe.openIosSettings()
    }

    private func rateInAppStore() {
        let appStoreReviewLink = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(fomoId.appStoreId)"
        wireframe.reviewOnAppStore(appStoreReviewLink)
    }
}
