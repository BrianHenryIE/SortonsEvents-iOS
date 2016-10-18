//
//  NewsViewProtocol.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//


protocol NewsViewControllerOutput {
    func setup(request: News.Fetch.Request)
}

protocol NewsPresenterOutput {
    func display(viewModel: News.ViewModel)
}
