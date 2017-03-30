//
//  MetaWebViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 19/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

protocol MetaWebViewPresenterOuput {
    func displayInWebView(processedHtml: String)
}

protocol MetaWebViewInteractorOuput {
    func displayHtml(html: String)
}

class MetaWebViewController: UIViewController, MetaWebViewPresenterOuput {

    @IBOutlet weak var webview: UIWebView!

    var rootViewController: UIViewController?
    var output: MetaWebViewInteractor?

    override func viewDidLoad() {
        super.viewDidLoad()

        output?.loadHtml()

        webview.delegate = self
    }

    func displayInWebView(processedHtml: String) {
        webview.loadHTMLString(processedHtml, baseURL: nil)
    }
}

extension MetaWebViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            if let url = request.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return false
        default:
            return true
        }
    }
}

class MetaWebViewPresenter: MetaWebViewInteractorOuput {

    let output: MetaWebViewPresenterOuput
    let fomoId: FomoId

    init(with output: MetaWebViewPresenterOuput, fomoId: FomoId) {
        self.output = output
        self.fomoId = fomoId
    }

    func displayHtml(html: String) {

        let processedHtml = replaceFomoNameIn(html: html, fomoId: fomoId)

        output.displayInWebView(processedHtml: processedHtml)
//        output.webview.loadHTMLString(processedHtml, baseURL: nil)
    }

    func replaceFomoNameIn(html: String, fomoId: FomoId) -> String {

        var stringWithReplacements = html.replacingOccurrences(of: "<fomo:longName>", with: fomoId.longName)

        stringWithReplacements = stringWithReplacements.replacingOccurrences(of: "<fomo:shortName>",
                                                                             with: fomoId.shortName)

        return stringWithReplacements
    }
}

class MetaWebViewInteractor {

    let output: MetaWebViewInteractorOuput
    let urlString: String

    init(with output: MetaWebViewInteractorOuput, for urlString: String) {
        self.output = output
        self.urlString = urlString
    }

    func loadHtml() {

        let urlObject = URL(string: urlString)!

        do {
            let htmlString = try String(contentsOf: urlObject)

            output.displayHtml(html: htmlString)
        } catch {

        }
    }
}
