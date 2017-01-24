//
//  NewsWireframe.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class MetaWireframe: NSObject {

    let storyboard = UIStoryboard(name: "Meta", bundle: Bundle.main)

    let fomoId: FomoId

    var metaNavigationView: UIViewController?

    var metaMainView: MetaViewController?

    var metaInteractor: MetaInteractor?

    var mailComposerVC = MFMailComposeViewController()

    var activityVC: UIActivityViewController?

    init(fomoId: FomoId) {

        self.fomoId = fomoId

        metaMainView = storyboard.instantiateViewController(withIdentifier: "Meta")
            as? MetaViewController

        guard let metaMainView = metaMainView else {
            super.init()
            return
        }

        metaNavigationView = UINavigationController(rootViewController: metaMainView)

        let metaPresenter = MetaPresenter(output: metaMainView)

        super.init()

        metaInteractor = MetaInteractor(wireframe: self,
                                           fomoId: fomoId,
                                        presenter: metaPresenter)

        metaMainView.output = metaInteractor
    }

    func presentWebView(for url: String) {

        let metaWebVC = storyboard.instantiateViewController(withIdentifier: "MetaWebViewController")
            as? MetaWebViewController

        guard let metaWebViewController = metaWebVC else {
            return
        }

        let metaWebViewPresenter = MetaWebViewPresenter(with: metaWebViewController,
                                                      fomoId: fomoId)

        let metaWebViewInteractor = MetaWebViewInteractor(with: metaWebViewPresenter,
                                                           for: url)

        metaWebViewController.output = metaWebViewInteractor

        metaNavigationView?.childViewControllers[0].navigationController?.pushViewController(metaWebViewController,
                                                                                  animated: true)
    }

    func share(_ objectsToShare: [Any]) {
        activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        guard let activityVC = activityVC else {
            return
        }

        activityVC.popoverPresentationController?.sourceView = metaNavigationView?.view
        activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

        let alertOrigin = CGPoint(x: (metaNavigationView?.view.frame.width ?? 1 / 2 - 160),
                                  y: (metaNavigationView?.view.frame.height ?? 1 / 2 - 100))

        let alertSize = CGSize(width: 320, height: 200)

        activityVC.popoverPresentationController?.sourceRect = CGRect(origin: alertOrigin,
                                                                        size: alertSize)

        metaNavigationView?.present(activityVC, animated: true, completion: nil)
    }

    // https://www.andrewcbancroft.com/2014/08/25/send-email-in-app-using-mfmailcomposeviewcontroller-with-swift/
    func sendFeedbackEmail(_ subject: String) {

        if MFMailComposeViewController.canSendMail() {
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["info@sortons.ie"])
            mailComposerVC.setSubject(subject)

            metaNavigationView?.present(mailComposerVC, animated: true, completion: nil)
        } else {
            metaInteractor?.showSendMailErrorAlert()
        }
    }

    func openIosSettings() {
        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
    }

    func reviewOnAppStore(_ link: String) {
        UIApplication.shared.openURL(URL(string: link)!)
    }
}

extension MetaWireframe: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                       didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
