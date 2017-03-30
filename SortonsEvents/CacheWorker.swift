//
//  CacheWorker.swift
//  SortonsEvents
//
//  Created by Brian Henry on 12/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

protocol CacheProtocol {

    func fetch<T: ImmutableMappable>() -> [T]?
    func save<T: ImmutableMappable>(_ latestData: [T]?)
}

class CacheWorker<T: ImmutableMappable>: CacheProtocol {

    private let fileURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                                   .userDomainMask, true).first!)
        .appendingPathComponent("\(T.self).json")

    func fetch<T: ImmutableMappable>() -> [T]? {

        guard let fileFromCache = try? String(contentsOf: fileURL) else {
            return nil
        }

        let eventsFromCache = try? Mapper<T>().mapArray(JSONString: fileFromCache)

        return eventsFromCache
    }

    func save<T: ImmutableMappable>(_ latestData: [T]?) {

        let data = latestData?.toJSONString(prettyPrint: false)

        try? data?.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}
