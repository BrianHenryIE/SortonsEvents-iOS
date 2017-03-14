//
//  Array+NilEmpty.swift
//  SortonsEvents
//
//  Created by Brian Henry on 21/01/2017.
//  Copyright © 2017 Sortons. All rights reserved.
//

import Foundation

public extension Array {
    /**
     Return nil when the array is empty
     */
    func nilEmpty() -> Array? {
        return self.isEmpty ? nil : self
    }
}
