//
//  ListEventsProtocols.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

protocol ListEventsPresenterOutput {
    func displaySomething(viewModel: ListEventsViewModel)
}

protocol ListEventsTableViewControllerOutput {
    func fetchEvents(request: ListEvents_FetchEvents_Request)
}
