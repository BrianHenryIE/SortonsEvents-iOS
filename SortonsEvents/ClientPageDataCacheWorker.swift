//
//  ClientPageDataCacheWorker.swift
//  SortonsEvents
//
//  Created by Brian Henry on 12/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation


protocol ClientPageDataCacheWorkerProtocol {
    
    func fetch(completionHandler: (clientPageData: String) -> Void)
    func save(latestClientPageData: String)
}

class ClientPageDataCacheWorker : ClientPageDataCacheWorkerProtocol {
    
    let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("fomo.json")
    
    func fetch(completionHandler: (clientPageData: String) -> Void) {
        
        // read file
        do {
            let fileFromCache = try String(contentsOfURL: fileURL)
            completionHandler(clientPageData: fileFromCache)
        } catch {
            // TODO / this will throw an error already when parsing
        }
    }
    
    func save(latestClientPageData: String) {
        
        let data = latestClientPageData.dataUsingEncoding(NSUTF8StringEncoding)
        
        do {
            try data!.writeToURL(fileURL, options: .AtomicWrite)
        } catch {
            // TODO
        }
    }
}