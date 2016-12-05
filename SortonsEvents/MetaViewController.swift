//
//  MetaViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

protocol MetaViewControllerOutput {

    func showWebView(for page: SettingsPage)

    func share()

    func sendFeedback(for type: FeedbackType)

    func openIosSettings()

    func rateInAppStore()
}

class MetaViewController: UITableViewController, MetaPresenterOutput {

    var output: MetaViewControllerOutput!

    @IBOutlet var tableview: UITableView!

    @IBOutlet weak var aboutCell: UITableViewCell!
    @IBOutlet weak var changeLogCell: UITableViewCell!
    @IBOutlet weak var privacyPolicyCell: UITableViewCell!

    // Log in/out of Facebook
    // Configure notifications

    @IBOutlet weak var shareCell: UITableViewCell!
    @IBOutlet weak var sendFeedbackCell: UITableViewCell!
    @IBOutlet weak var openIosSettingsCell: UITableViewCell!
    @IBOutlet weak var rateInTheAppStoreCell: UITableViewCell!

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        switch  selectedCell {
        case aboutCell:
            output.showWebView(for:.about)
        case changeLogCell:
            output.showWebView(for: .changelog)
        case privacyPolicyCell:
            output.showWebView(for: .privacyPolicy)
        case shareCell:
            output.share()
        case sendFeedbackCell:
            showFeedbackTypeAlert()
        case openIosSettingsCell:
            output.openIosSettings()
        case rateInTheAppStoreCell:
            output.rateInAppStore()
        default:
            NSLog("unexpected cell: \(selectedCell.textLabel?.text)")
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func showFeedbackTypeAlert() {
        let alert = UIAlertController(title: nil,
                                      message: "What is the feedback about?",
                                      preferredStyle: .actionSheet)
        let praiseAction = UIAlertAction(title: "Praise!",
                                        style: .default) { (alert: UIAlertAction!) -> Void in
                                            self.output.sendFeedback(for: .praise)
        }
        let suggestionAction = UIAlertAction(title: "Suggestion",
                                            style: .default) { (alert: UIAlertAction!) -> Void in
                                                self.output.sendFeedback(for: .suggestion)
        }
        let complaintAction = UIAlertAction(title: "Complaint",
                                            style: .default) { (alert: UIAlertAction!) -> Void in
                                                self.output.sendFeedback(for: .complaint)
        }
        alert.addAction(suggestionAction)
        alert.addAction(praiseAction)
        alert.addAction(complaintAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion:nil)
    }

}