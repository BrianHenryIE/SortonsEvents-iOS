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

fileprivate class OutputSpy: DirectoryPresenterOutputProtocol {

    var viewModel: Directory.ViewModel?
    var presentFetchedDirectoryCalled = false

    func presentFetchedDirectory(_ viewModel: Directory.ViewModel) {
        presentFetchedDirectoryCalled = true
        self.viewModel = viewModel
    }

    func displayFetchDirectoryFetchError(_ viewModel: Directory.ViewModel) {
        // TODO
    }
}

class DirectoryPresenterTests: XCTestCase {

    fileprivate var outputSpy = OutputSpy()
    var sut: DirectoryInteractorOutputProtocol!

    override func setUp() {
        super.setUp()

        sut = DirectoryPresenter(output: outputSpy)
    }

    func testPresentFetchedDirectory() {

        // Get some test data
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "ClientPageDataTcd", ofType: "json")!
        var content = "{}"
        do {
            content = try String(contentsOfFile: path)
        } catch {
        }
        let tcdEvents: ClientPageData = Mapper<ClientPageData>().map(JSONString: content)!

        sut.presentFetchedDirectory(Directory.Fetch.Response(directory: tcdEvents.includedPages))

        XCTAssert(outputSpy.presentFetchedDirectoryCalled, "Presenter did not pass anything to view")

        XCTAssertEqual(325, outputSpy.viewModel?.directory.count, "Error building viewmodel in presenter")
    }

//    func testDisplayFetchDirectoryFetchError() {
//        
//        let viewModel: DirectoryViewModel
//        
//        sut.displayFetchDirectoryFetchError(viewModel)
//    }

}
