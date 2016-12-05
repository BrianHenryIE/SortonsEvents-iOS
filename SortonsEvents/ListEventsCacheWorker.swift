//
//  ListEventsCacheWorker.swift
//  SortonsEvents
//
//  Created by Brian Henry on 12/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

protocol ListEventsCacheWorkerProtocol {

    func fetch() -> String?
    func save(_ latestClientPageData: String)
}

class ListEventsCacheWorker: ListEventsCacheWorkerProtocol {

    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("discoveredevents.json")

    func fetch() -> String? {

        // read file
        do {
            let fileFromCache = try String(contentsOf: fileURL)
            return fileFromCache
        } catch {
            // TODO / this will throw an error already when parsing
        }

        return nil
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
