//
//  NewsViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import WebKit

extension News {
    struct Request {}
}

protocol NewsViewControllerOutputProtocol {
    func open(_ url: URL)

    func setup(_ request: News.Request)
}

class NewsViewController: UIViewController, NewsPresenterOutputProtocol {

    var webview: WKWebView?

    var output: NewsViewControllerOutputProtocol?
    var newsUrl: URLRequest!

    var initialViewportSet = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        fetchNews()
    }

    func setupView() {

        webview = WKWebView(frame: self.view.frame)

        webview?.navigationDelegate = self

        view.addSubview(webview!)
    }

    func fetchNews() {
        let request = News.Request()
        output?.setup(request)
    }

    func display(_ viewModel: News.ViewModel) {
        newsUrl = viewModel.newsUrlRequest
        _ = webview?.load(newsUrl)
    }

    func setViewPort(width: CGFloat) {
        webview?.evaluateJavaScript("setViewPortSizeAndRefresh( \(width) )",
                                   completionHandler: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        webview?.isHidden = true
        self.setViewPort(width: size.width)

        coordinator.animate(alongsideTransition: { _ in

            self.webview?.frame = CGRect(x: 0,
                                        y: 0,
                                    width: size.width,
                                   height: size.height)
        },
                            completion: { _ in
                                self.webview?.isHidden = false
        })
    }
}

extension NewsViewController: WKNavigationDelegate {

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
            if let url = navigationAction.request.urlRequest?.url {
                output?.open(url)
            }
            decisionHandler(.cancel)
            break
        default:
            decisionHandler(.allow)
            break
        }
    }
}
