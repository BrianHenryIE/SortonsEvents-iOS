//
//  XCTestCase+ReadJsonFile.swift
//  SortonsEvents
//
//  Created by Brian Henry on 22/01/2017.
//  Copyright © 2017 Sortons. All rights reserved.
//

import XCTest

extension XCTestCase {

    /**
     * Reads filename of type json
     * Fails and stops the test if the file can't be read
     */
    func readJsonFile(filename: String) -> String {
        let bundle = Bundle(for: self.classForCoder)
        guard let path = bundle.path(forResource: filename, ofType: "json"),
            let content = try? String(contentsOfFile: path) else {
                continueAfterFailure = false
                XCTFail("File error")
                return ""
        }
        return content
    }
}
