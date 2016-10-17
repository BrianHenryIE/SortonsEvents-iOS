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

class NewsViewController: UIViewController, NewsViewInput {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Move to presenter
    func loadNewsForId(_ id: String) {
        
        // Move to presenter
        let urlString = "https://sortonsevents.appspot.com/recentpostsmobile/news.html#%\(id)"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        setWebViewUrl(urlRequest)
        
        // When the view is preloaded, the content is loaded at the wrong width, so I'm hiding the view until I've told it to refresh (and it will at least be cached)
//        self.webView.hidden = YES;
    }

    func setWebViewUrl(_ urlRequest: URLRequest) {
        webView.loadRequest(urlRequest)
    }
}
