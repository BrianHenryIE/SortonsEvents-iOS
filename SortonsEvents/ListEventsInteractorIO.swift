//
//  EventsInteractorIO.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

protocol ListEventsInteractorOutput {
    
    func presentFetchedEvents(upcomingEvents: ListEvents_FetchEvents_Response)
}

