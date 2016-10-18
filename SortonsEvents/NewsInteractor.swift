//
//  NewsViewInteractor.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

class NewsInteractor: NewsViewControllerOutput {
    
    let output: NewsInteractorOutput!
    
    let fomoId: String!
    
    init(fomoId: String, output: NewsInteractorOutput) {
        self.fomoId = fomoId
        self.output = output
    }
    
    func setup(request: News.Fetch.Request) {
        output.setFomoId(fomoId)
    }
}
