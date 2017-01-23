//
//  ListEventsNetworkWorker.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

protocol ListEventsNetworkProtocol {
    func fetchEvents(_ fomoId: String, completionHandler: @escaping (_ result: Result<[DiscoveredEvent]>) -> Void)
}

class ListEventsNetworkWorker: ListEventsNetworkProtocol {

    let baseUrl = "https://sortonsevents.appspot.com/_ah/api/upcomingEvents/v1/discoveredeventsresponse/"

    func fetchEvents(_ fomoId: String, completionHandler: @escaping (Result<[DiscoveredEvent]>) -> Void) {

        let endpoint = "\(baseUrl)\(fomoId)"

//        Alamofire.request(endpoint).responseArray(keyPath: "data") { (response: DataResponse<[DiscoveredEvent]>) in
//
//            completionHandler(response.result)
//        }

        Alamofire.request(endpoint)
            .responseString { response in

                if let json = response.result.value {

                    if let gaeResponse = try? Mapper<DiscoveredEventsResponse>().map(JSONString: json) {
                        let events = gaeResponse.data!

                        completionHandler(Result<[DiscoveredEvent]>.success(events))

                    }
                }
        }

    }
}
