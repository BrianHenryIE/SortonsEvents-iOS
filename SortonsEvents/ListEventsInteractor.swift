//
//  EventsInteractor.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

class ListEventsInteractor : NSObject, ListEventsTableViewControllerOutput {
    
    let fomoId : String
    let output : ListEventsInteractorOutput
    let listEventsNetworkWorker : ListEventsNetworkWorkerProtocol
    let listEventsCacheWorker : ListEventsCacheWorkerProtocol

    init(fomoId: String, output : ListEventsInteractorOutput, listEventsNetworkWorker : ListEventsNetworkWorkerProtocol, listEventsCacheWorker : ListEventsCacheWorkerProtocol){
        self.fomoId = fomoId
        self.output = output
        self.listEventsNetworkWorker = listEventsNetworkWorker
        self.listEventsCacheWorker = listEventsCacheWorker
    }
    
    func fetchEvents(request: ListEvents_FetchEvents_Request) {
        
        // Get from cache
        listEventsCacheWorker.fetch { (cacheString) -> Void in
            let eventsFromCache : DiscoveredEventsResponse = Mapper<DiscoveredEventsResponse>().map(cacheString)!
            if let data = eventsFromCache.data {
                let response = ListEvents_FetchEvents_Response(events: data)
                self.output.presentFetchedEvents(response)
            }
        }
        
        // Get from network
        listEventsNetworkWorker.fetchEvents(fomoId) { (discoveredEventsJsonPage) -> Void in
            
            // parse from json
            let discoveredEventsResponse : DiscoveredEventsResponse = Mapper<DiscoveredEventsResponse>().map(discoveredEventsJsonPage)!
            
            if let data = discoveredEventsResponse.data {
                // save to cache
                self.listEventsCacheWorker.save(discoveredEventsJsonPage)
                
                let response = ListEvents_FetchEvents_Response(events: data)
                self.output.presentFetchedEvents(response)
            }
        }
    }
}
