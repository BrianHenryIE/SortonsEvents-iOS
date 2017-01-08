//
//  NewsViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

//Important
//Before releasing an instance of UIWebView for which you have set a delegate, 
//you must first set the UIWebView delegate property to nil before disposing 
//of the UIWebView instance. This can be done, for example, in the dealloc 
//method where you dispose of the UIWebView.

class NewsViewController: UIViewController, NewsPresenterOutput {

    @IBOutlet weak var webview: UIWebView!

    var output: NewsViewControllerOutput!
    var newsUrl: URLRequest!

    var initialViewportSet = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = News.Fetch.Request()

        webview.delegate = self
        webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal

        output.setup(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func display(_ viewModel: News.ViewModel) {
        newsUrl = viewModel.newsUrl
        webview.loadRequest(newsUrl)

    }

    func setViewPort() {
        webview.stringByEvaluatingJavaScript(from: "setViewPortSizeAndRefresh( \(self.view.bounds.width) )")
        // aka
        // javascript:setViewPortSizeAndRefresh(1000)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        webview.isHidden = true

        coordinator.animate(alongsideTransition: nil,
                            completion: { _ in
                                self.setViewPort()
                                self.webview.isHidden = false
        })
    }
}

extension NewsViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            output.open(request.url!)
            return false
        default:
            return true
        }
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {

        if !initialViewportSet {
            setViewPort()
            initialViewportSet = true
        }

    }
}
