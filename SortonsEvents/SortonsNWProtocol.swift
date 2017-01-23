//
//  SortonsNWProtocol.swift
//  SortonsEvents
//
//  Created by Brian Henry on 22/01/2017.
//  Copyright © 2017 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 * Protocol to allow a single network worker fetch generic types
 */
protocol SortonsNW {
    static var endpointBase: String { get }
    static var keyPath: String { get }
}
