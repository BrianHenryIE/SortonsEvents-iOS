//
//  DirectoryPresenterTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest
import ObjectMapper

fileprivate class OutputMock: DirectoryPresenterOutputProtocol {

    var asyncExpectation: XCTestExpectation?

    var viewModel: Directory.ViewModel?
    var presentFetchedDirectoryCalled = false

    func presentFetchedDirectory(_ viewModel: Directory.ViewModel) {
        presentFetchedDirectoryCalled = true
        self.viewModel = viewModel
        asyncExpectation?.fulfill()
    }

    func displayFetchDirectoryFetchError(_ viewModel: Directory.ViewModel) {

        asyncExpectation?.fulfill()
    }
}

class DirectoryPresenterTests: XCTestCase {

    fileprivate var outputMock: OutputMock!
    var sut: DirectoryInteractorOutputProtocol!

    override func setUp() {
        super.setUp()

        outputMock = OutputMock()

        let asyncExpectation = expectation(description: "MetaPresenterTests")
        outputMock.asyncExpectation = asyncExpectation

        sut = DirectoryPresenter(output: outputMock)
    }

    func testPresentFetchedDirectory() {

        let content = readJsonFile(filename: "ClientPageDataTcd")

        guard let tcdEvents: ClientPageData = try? Mapper<ClientPageData>().map(JSONString: content) else {
            XCTFail()
            return
        }

        sut.presentFetchedDirectory(Directory.Fetch.Response(directory: tcdEvents.includedPages))

        waitForExpectations(timeout:5, handler: nil)

        XCTAssert(outputMock.presentFetchedDirectoryCalled, "Presenter did not pass anything to view")

        XCTAssertEqual(325, outputMock.viewModel?.directory.count, "Error building viewmodel in presenter")
    }

//    func testDisplayFetchDirectoryFetchError() {
//        
//        let viewModel: DirectoryViewModel
//        
//        sut.displayFetchDirectoryFetchError(viewModel)
//    }

}
