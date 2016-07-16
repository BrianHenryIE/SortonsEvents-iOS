//
//  EventsInteractorIO.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

//
//protocol ListEventsViewControllerOutput {
//    func fetchEvents(request: ListEvents_FetchEvents_Request)
//    
//    // func reportEvent(id: String, message : String)
//    
//    // send feedback: general/page to add
//    
//    // analytics!
//    
//}


protocol ListEventsInteractorOutput {
    func presentFetchedEvents(upcomingEvents: ListEvents_FetchEvents_Response)
}

