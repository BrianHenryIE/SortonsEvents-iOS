//
//  MetaInteractor.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

protocol MetaInteractorOutput {

}

enum SettingsPage {
    case about, changelog, privacyPolicy
}

enum FeedbackType {
    case suggestion, praise, complaint
}

class MetaInteractor: MetaViewControllerOutput {

    let presenter: MetaInteractorOutput

    let fomoId: FomoId
    let wireframe: MetaWireframe

    init(wireframe: MetaWireframe, fomoId: FomoId, presenter: MetaInteractorOutput) {
        self.presenter = presenter
        self.fomoId = fomoId
        self.wireframe = wireframe
    }

    func showWebView(for page: SettingsPage) {
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

    func share() {
        let shareText = "Check out \(fomoId.name) on the App Store"
        let url = "https://itunes.apple.com/app/id\(fomoId.appStoreId)"

        let appStoreLink = URL(string: url)!

        let objectsToShare = [shareText, appStoreLink] as [Any]

        wireframe.share(objectsToShare)
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
        wireframe.sendFeedbackEmail(subject)
    }

    func openIosSettings() {
        wireframe.openIosSettings()
    }

    func rateInAppStore() {
        let appStoreReviewLink = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(fomoId.appStoreId)"
        wireframe.reviewOnAppStore(appStoreReviewLink)
    }
}
