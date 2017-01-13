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

        setupView()

        fetchNews()
    }

    func setupView() {

        webView = WKWebView(frame: self.view.frame)

        webView.navigationDelegate = self

        view.addSubview(webView)
    }

    func fetchNews() {
        let request = News.Fetch.Request()
        output.setup(request)
    }

    func display(_ viewModel: News.ViewModel) {
        newsUrl = viewModel.newsUrl
        _ = webView.load(newsUrl)
    }

    func setViewPort(width: CGFloat) {
        webView.evaluateJavaScript("setViewPortSizeAndRefresh( \(width) )",
                                   completionHandler: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        webView.isHidden = true
        self.setViewPort(width: size.width)

        coordinator.animate(alongsideTransition: { _ in
            // TODO: do this with autolayout!
            self.webView.frame = CGRect(x: 0,
                                        y: 0,
                                    width: size.width,
                                   height: size.height)
        },
                            completion: { _ in
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
            setViewPort(width: self.view.bounds.width)
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
