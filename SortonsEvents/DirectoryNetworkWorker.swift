//
//  DirectoryNetworkWorker.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import Alamofire

protocol DirectoryNetworkWorkerProtocol {
    func fetchDirectory(_ fomoId: String, completionHandler: @escaping (_ discoveredEventsJsonPage: String) -> Void)
}

class DirectoryNetworkWorker: DirectoryNetworkWorkerProtocol {
    
    let baseUrl = "https://sortonsevents.appspot.com/_ah/api/clientdata/v1/clientpagedata/"
    
    func fetchDirectory(_ fomoId: String, completionHandler: @escaping (_ discoveredEventsJsonPage: String) -> Void) {
        
        let endpoint = "\(baseUrl)\(fomoId)"
        
        Alamofire.request(endpoint)
            .responseString { response in
                completionHandler(response.result.value!)
        }
    }
}
