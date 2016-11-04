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

    @IBOutlet weak var webView: UIWebView!
    
    var output: NewsViewControllerOutput!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = News.Fetch.Request()
        
        output.setup(request: request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func display(viewModel: News.ViewModel) {
        webView.loadRequest(viewModel.newsUrl)
    }

    @IBAction func changeToNextTabLeft(_ sender: Any) {
        output.changeToNextTabLeft()
    }
    
    @IBAction func changeToNextTabRight(_ sender: Any) {
        output.changeToNextTabRight()
    }
    
}
