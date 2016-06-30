//
//  ClientPageDataCacheWorker.swift
//  SortonsEvents
//
//  Created by Brian Henry on 12/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

class ClientPageDataCacheWorker {
    
    let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("fomo.json")
    
    func fetchClientPageData() -> String {
        
        // read file
        do {
            let fileFromCache = try String(contentsOfURL: fileURL)
            return fileFromCache
        } catch {
            // TODO / this will throw an error already when parsing
            return "{}"
        }
        
        // Filter to future events in presenter
    }
    
    func saveClientPageDataToCache(newClientPageData: NSString) {
        
        let data = newClientPageData.dataUsingEncoding(NSUTF8StringEncoding)
        
        do {
            try data!.writeToURL(fileURL, options: .AtomicWrite)
        } catch {
            // TODO
        }
    }
}