//
//  NewsViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController, NewsPresenterOutput {

    var webView: WKWebView!

    var output: NewsViewControllerOutput!
    var newsUrl: URLRequest!

    var initialViewportSet = false

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self

        self.view.addSubview(webView)

        let request = News.Fetch.Request()
        output.setup(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func display(_ viewModel: News.ViewModel) {
        newsUrl = viewModel.newsUrl
        _ = webView.load(newsUrl)
    }

    func setViewPort() {
        webView.evaluateJavaScript("setViewPortSizeAndRefresh( \(self.view.bounds.width) )", completionHandler: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        webView.isHidden = true

        coordinator.animate(alongsideTransition: nil,
                            completion: { _ in
                                self.setViewPort()
                                self.webView.isHidden = false
        })
    }
}

extension NewsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !initialViewportSet {
            setViewPort()
            initialViewportSet = true
        }
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        switch navigationAction.navigationType {
        case .linkActivated:
            output.open(navigationAction.request.urlRequest!.url!)
            decisionHandler(.cancel)
            break
        default:
            decisionHandler(.allow)
            break
        }
    }
}
