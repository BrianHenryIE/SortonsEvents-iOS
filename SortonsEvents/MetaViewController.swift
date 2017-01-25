//
//  MetaViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import MessageUI

protocol MetaViewControllerOutputProtocol {

    func sendFeedback(for type: FeedbackType)

    func selectedCell(at indexPath: IndexPath)
}

class MetaViewController: UITableViewController, MetaPresenterOutputProtocol {

    var rootViewController: UIViewController?
    var output: MetaViewControllerOutputProtocol?

    var activityVC: UIActivityViewController?

    @IBOutlet var tableview: UITableView!

    var alert: UIAlertController!

    override func viewDidLoad() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        output?.selectedCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func showFeedbackTypeAlert() {
        alert = UIAlertController(title: nil,
                                      message: "What is the feedback about?",
                                      preferredStyle: .actionSheet)
        let praiseAction = UIAlertAction(title: "Praise!",
                                        style: .default) { (alert: UIAlertAction!) -> Void in
                                            self.output?.sendFeedback(for: .praise)
        }
        let suggestionAction = UIAlertAction(title: "Suggestion",
                                            style: .default) { (alert: UIAlertAction!) -> Void in
                                                self.output?.sendFeedback(for: .suggestion)
        }
        let complaintAction = UIAlertAction(title: "Complaint",
                                            style: .default) { (alert: UIAlertAction!) -> Void in
                                                self.output?.sendFeedback(for: .complaint)
        }
        alert.addAction(suggestionAction)
        alert.addAction(praiseAction)
        alert.addAction(complaintAction)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                       handler: nil)
        alert.addAction(cancelAction)

        alert.modalPresentationStyle = .popover

        let alertOrigin = CGPoint(x: self.view.frame.width / 2 - 160,
                                  y: self.view.frame.height / 2 - 100)

        let alertSize = CGSize(width: 320, height: 200)

        alert.popoverPresentationController?.sourceRect = CGRect(origin: alertOrigin,
                                                                   size: alertSize)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

        rootViewController?.present(alert, animated: true, completion:nil)
    }

    func showErrorAlert(title: String, message: String) {

        let alertController = UIAlertController(title: title,
                                              message: message,
                                       preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // ...
        }
        alertController.addAction(okAction)

        self.present(alertController, animated: true) {
            // ...
        }
    }

    func share(_ objectsToShare: [Any]) {
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.popoverPresentationController?.sourceView = view
        activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

        let alertOrigin = CGPoint(x: (view.frame.width / 2 - 160),
                                  y: (view.frame.height / 2 - 100))

        let alertSize = CGSize(width: 320, height: 200)

        activityVC.popoverPresentationController?.sourceRect = CGRect(origin: alertOrigin,
                                                                      size: alertSize)

        rootViewController?.present(activityVC, animated: true, completion: nil)
    }

    func sendFeedbackEmail(to address: String, with subject: String) {

        let mailComposerVC = MFMailComposeViewController()

        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([address])
        mailComposerVC.setSubject(subject)

        rootViewController?.present(mailComposerVC, animated: true, completion: nil)
    }
}

extension MetaViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
