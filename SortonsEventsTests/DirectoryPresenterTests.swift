//
//  DirectoryPresenterTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents
import ObjectMapper

class ViewControllerSpy: DirectoryPresenterOutput {
    
    var viewModel: DirectoryViewModel?
    var presentFetchedDirectoryCalled = false
    
    func presentFetchedDirectory(_ viewModel: DirectoryViewModel) {
        presentFetchedDirectoryCalled = true
        self.viewModel = viewModel
    }
    
    func displayFetchDirectoryFetchError(_ viewModel: DirectoryViewModel) {
        // TODO
    }
}


class DirectoryPresenterTests: XCTestCase {
    
    var spy = ViewControllerSpy()
    var sut: DirectoryInteractorOutput!
    
    override func setUp() {
        super.setUp()
        
        sut = DirectoryPresenter(output: spy)
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
        
        sut.presentFetchedDirectory(Directory_FetchDirectory_Response(directory: tcdEvents.includedPages))
        
        XCTAssert(spy.presentFetchedDirectoryCalled, "Presenter did not pass anything to view")
        
        XCTAssertEqual(325, spy.viewModel?.directory.count, "Error building viewmodel in presenter")
    }

//    func testDisplayFetchDirectoryFetchError() {
//        
//        let viewModel: DirectoryViewModel
//        
//        sut.displayFetchDirectoryFetchError(viewModel)
//    }
    
}
