//
//  NewsViewPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

// Overkill! lolz

class NewsPresenter: NewsInteractorOutput {
    
    let output: NewsPresenterOutput!
    
    init(output: NewsPresenterOutput){
        self.output = output
    }
    
    func setFomoId(_ id: String) {
        // Move to presenter
        let urlString = "https://sortonsevents.appspot.com/recentpostsmobile/news.html#\(id)"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        let viewModel = News.ViewModel(newsUrl: urlRequest)
        
        output.display(viewModel: viewModel)
        
        // When the view is preloaded, the content is loaded at the wrong width, so I'm hiding the view until I've told it to refresh (and it will at least be cached)
        //        self.webView.hidden = YES;
    }
 
    
    
    
}
