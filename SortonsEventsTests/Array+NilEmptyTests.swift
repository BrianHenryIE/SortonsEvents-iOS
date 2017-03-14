//
//  Array+NilEmptyTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 3/13/17.
//  Copyright © 2017 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

class ArrayNilEmptyTests: XCTestCase {

    func testEmpty() {

        let arr1 = [String]()

        XCTAssertNotNil(arr1)

        let arr2 = arr1.nilEmpty()

        XCTAssertNil(arr2)
    }

    func testNotEmpty() {

        let arr1 = ["item1", "item2"]

        XCTAssertNotNil(arr1)

        let arr2 = arr1.nilEmpty()

        XCTAssertNotNil(arr2)
    }
}
