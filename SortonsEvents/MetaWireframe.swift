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

class MetaWireframe: NSObject{
    
    let storyboard = UIStoryboard(name: "Meta", bundle: Bundle.main)
    
    let metaView: UIViewController!
    var rootViewController : RootViewControllerProtocol?
    
    init(fomoId: FomoId) {
        
        // swiftlint:disable:next force_cast
        let metaMainView = storyboard.instantiateViewController(withIdentifier: "Meta") as! MetaViewController
        
        let metaPresenter = MetaPresenter(output: metaMainView)

        metaView = UINavigationController(rootViewController: metaMainView)
        
        super.init()
        
        let metaInteractor = MetaInteractor(wireframe: self, fomoId: fomoId, presenter: metaPresenter)
        
        metaMainView.output = metaInteractor
    }
    
    func presentWebView(for url: String) {
        // swiftlint:disable:next force_cast
        let metaWebView = storyboard.instantiateViewController(withIdentifier: "MetaWebViewController") as! MetaWebViewController
        
        metaWebView.url = url
        
        metaView.childViewControllers[0].navigationController?.pushViewController(metaWebView, animated: true)
    }
    
    func share(_ objectsToShare: [Any]) {
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = nil
        metaView.present(activityVC, animated: true, completion: nil)
    }
    
    // https://www.andrewcbancroft.com/2014/08/25/send-email-in-app-using-mfmailcomposeviewcontroller-with-swift/
    func sendFeedbackEmail(_ subject: String) {
        
        let mailComposerVC = MFMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["info@sortons.ie"])
            mailComposerVC.setSubject(subject)
            
            metaView.present(mailComposerVC, animated: true, completion: nil)
        } else {
            //  TODO          output.showSendMailErrorAlert()
        }
    }
    
    func changeToNextTabLeft() {
        if let rootViewController = rootViewController {
            rootViewController.changeToNextTabLeft()
        }
    }
    
    func changeToNextTabRight() {
        if let rootViewController = rootViewController {
            rootViewController.changeToNextTabRight()
        }
    }
}

extension MetaWireframe: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
