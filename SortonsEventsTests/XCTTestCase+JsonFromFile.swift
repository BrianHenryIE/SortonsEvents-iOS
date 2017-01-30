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
     * Returns as a String
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

    /**
     * Reads filename of type json
     * Returns as Data
     * Fails and stops the test if the file can't be read
     */
    func readJsonData(filename: String) -> Data {
        let bundle = Bundle(for: self.classForCoder)
        guard let path = bundle.path(forResource: filename, ofType: "json"),
            let jsonFromFile = NSData(contentsOfFile: path) as? Data else {
                continueAfterFailure = false
                XCTFail("File error")
                return Data()
        }
        return jsonFromFile
    }

}
