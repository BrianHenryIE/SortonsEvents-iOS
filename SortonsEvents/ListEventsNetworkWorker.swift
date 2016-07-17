//
//  EventsDataManager.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import Alamofire

protocol ListEventsNetworkWorkerProtocol {
    func fetchEvents(fomoId : String, completionHandler: (discoveredEventsJsonPage: String) -> Void)
}

class ListEventsNetworkWorker : ListEventsNetworkWorkerProtocol {
    
    // What's the correct thing to do if there's no network?
    // i.e. how to pass back exceptions to UI and handle repeating
    
    // Should this be in a plist?
    // Ideally it can be changed OTA
    let baseUrl = "https://sortonsevents.appspot.com/_ah/api/upcomingEvents/v1/discoveredeventsresponse/"
    
    func fetchEvents(fomoId: String, completionHandler: (discoveredEventsJsonPage: String) -> Void) {
        
        let endpoint = "\(baseUrl)\(fomoId)"
        
        Alamofire.request(.GET, endpoint)
            .responseString { response in
                completionHandler(discoveredEventsJsonPage: response.result.value!)
        }
    }
}