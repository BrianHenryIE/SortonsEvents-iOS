//
//  EventsCacheWorker.swift
//  SortonsEvents
//
//  Created by Brian Henry on 12/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

// Is a cache folder the best approach? i.e. if someone has low space on their 
// phone, the cache is going to be wiped within hours... is that best for FOMO?

protocol ListEventsCacheWorkerProtocol {

    func fetch(completionHandler: (discoveredEvents: String) -> Void)
    func save(latestDiscoveredEvents: String)
}

class ListEventsCacheWorker : ListEventsCacheWorkerProtocol {
    
    func fetch(completionHandler: (discoveredEvents: String) -> Void)
    {
        // read file
        
        completionHandler(discoveredEvents: "")
        
        // Filter to future events in presenter
    }
    
    func save(latestEvents: String) {
        
    }

}