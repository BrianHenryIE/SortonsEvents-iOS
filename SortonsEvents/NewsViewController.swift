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

    @IBAction func changeToNextTabLeft(_ sender: Any) {
        output.changeToNextTabLeft()
    }

    @IBAction func changeToNextTabRight(_ sender: Any) {
        output.changeToNextTabRight()
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
}
