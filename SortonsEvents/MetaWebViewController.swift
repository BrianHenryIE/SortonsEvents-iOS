//
//  MetaWebViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 19/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

class MetaWebViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!

    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlRequest = URLRequest(url: URL(string: url!)!)

        webview.loadRequest(urlRequest)

        webview.delegate = self
    }

}

extension MetaWebViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            UIApplication.shared.openURL(request.url!)
            return false
        default:
            return true
        }
    }
}
