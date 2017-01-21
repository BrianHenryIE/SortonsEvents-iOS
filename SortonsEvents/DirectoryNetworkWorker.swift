//
//  DirectoryNetworkWorker.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import Alamofire

protocol DirectoryNetworkProtocol {
    func fetchDirectory(_ fomoId: String, completionHandler: @escaping (_ discoveredEventsJsonPage: String) -> Void)
}

class DirectoryNetworkWorker: DirectoryNetworkProtocol {

    let baseUrl = "https://sortonsevents.appspot.com/_ah/api/clientdata/v1/clientpagedata/"

    func fetchDirectory(_ fomoId: String, completionHandler: @escaping (_ discoveredEventsJsonPage: String) -> Void) {

        let endpoint = "\(baseUrl)\(fomoId)"

        Alamofire.request(endpoint)
            .responseString { response in
                // TODO: return an 'offline' message if nothing returned
                // Server down, no coverage...
                if let json = response.result.value {
                    completionHandler(json)
                }
        }
    }
}
