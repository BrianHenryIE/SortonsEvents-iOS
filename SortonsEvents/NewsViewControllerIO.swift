//
//  NewsViewProtocol.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//
import WebKit

protocol NewsViewControllerOutput {
    func open(url: URL)

    func setup(_ request: News.Fetch.Request)

    func changeToNextTabLeft()

    func changeToNextTabRight()
}

protocol NewsPresenterOutput {
    func display(_ viewModel: News.ViewModel)
}
