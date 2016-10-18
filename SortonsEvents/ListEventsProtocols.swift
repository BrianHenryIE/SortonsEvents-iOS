//
//  ListEventsProtocols.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

// View input
protocol ListEventsPresenterOutput {
    func presentFetchedEvents(_ viewModel: ListEventsViewModel)
    
    func displayFetchEventsFetchError(viewModel: ListEventsViewModel)
}

protocol ListEventsTableViewControllerOutput {
    func fetchEvents(_ request: ListEvents_FetchEvents_Request)
    
    func displayEvent(for rowNumber: Int)
}
