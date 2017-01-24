//
//  NewsViewPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

extension News {
    struct ViewModel {
        let newsUrl: URLRequest
    }
}

protocol NewsPresenterOutputProtocol {
    func display(_ viewModel: News.ViewModel)
}

class NewsPresenter: NewsInteractorOutputProtocol {

    let output: NewsPresenterOutputProtocol?

    init(output: NewsPresenterOutputProtocol?) {
        self.output = output
    }

    func setFomoId(_ fomoId: String) {

        let urlString = "http://sortons.ie/events/recentpostsmobile/news.html#\(fomoId)"
        guard let url = URL(string: urlString) else {
            return
        }
        let urlRequest = URLRequest(url: url)

        let viewModel = News.ViewModel(newsUrl: urlRequest)

        output?.display(viewModel)
    }

}
