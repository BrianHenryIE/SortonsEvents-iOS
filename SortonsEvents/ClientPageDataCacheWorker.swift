//
//  ClientPageDataCacheWorker.swift
//  SortonsEvents
//
//  Created by Brian Henry on 12/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

protocol ClientPageDataCacheWorkerProtocol {
    
    func fetch(_ completionHandler: (_ clientPageData: String) -> Void)
    func save(_ latestClientPageData: String)
}

class ClientPageDataCacheWorker: ClientPageDataCacheWorkerProtocol {
    
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("fomo.json")
    
    func fetch(_ completionHandler: (_ clientPageData: String) -> Void) {
        
        // read file
        do {
            let fileFromCache = try String(contentsOf: fileURL)
            completionHandler(fileFromCache)
        } catch {
            // TODO / this will throw an error already when parsing
        }
    }
    
    func save(_ latestClientPageData: String) {
        
        let data = latestClientPageData.data(using: String.Encoding.utf8)
        
        do {
            try data!.write(to: fileURL, options: .atomicWrite)
        } catch {
            // TODO
        }
    }
}
