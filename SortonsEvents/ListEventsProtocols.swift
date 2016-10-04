//
//  ListEventsProtocols.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

protocol ListEventsTableViewControllerOutput {
    func fetchEvents(_ request: ListEvents_FetchEvents_Request)
}

protocol ListEventsPresenterOutput {
    func presentFetchedEvents(_ viewModel: ListEventsViewModel)
}
