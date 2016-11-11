//
//  DirectoryViewControllerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

class TableViewSpy: UITableView {
    // MARK: Method call expectations
    var reloadDataCalled = false
    
    // MARK: Spied methods
    override func reloadData() {
        reloadDataCalled = true
    }
}
class DirectoryViewControllerOutputSpy: DirectoryViewControllerOutput {
    
    // MARK: Method call expectations
    var fetchDirectoryCalled = false
    var filterDirectoryToCalled = false
    var displaySelectedPageCalled = false
    var changeToNextTabLeftCalled = false
    
    func fetchDirectory(withRequest: Directory_FetchDirectory_Request) {
        fetchDirectoryCalled = true
    }
    
    func filterDirectoryTo(searchBarInput: String) {
        filterDirectoryToCalled = true
    }
    
    func displaySelectedPageFrom(rowNumber: Int) {
        displaySelectedPageCalled = true
    }
    
    func changeToNextTabLeft() {
        changeToNextTabLeftCalled = true
    }
}

class DirectoryViewControllerTests: XCTestCase {
    
    var sut: DirectoryViewController!
    let spy = DirectoryViewControllerOutputSpy()
    var directoryViewModel: DirectoryViewModel!
    
    override func setUp() {
        super.setUp()

        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Directory", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "Directory") as? DirectoryViewController
        
        sut.output = spy
        
        // Call viewDidLoad()
        let _ = sut.view
        
        // TODO change URL to local so tests don't need network
        let sampleImageUrl: URL = URL(string: "https://graph.facebook.com/206961869324550/picture?type=square")!
        let sampleDirectoryEntry = DirectoryTableViewCellModel(name: "test entry", details: "no details", imageUrl: sampleImageUrl)
        let sampleDirectoryModel = [sampleDirectoryEntry]
        directoryViewModel = DirectoryViewModel(directory: sampleDirectoryModel)
    }

    func testViewDidLoadShouldCallFetchDirectory() {
        XCTAssert(spy.fetchDirectoryCalled, "View not initializing as expected – should fetch directory on load")
    }
    
    func testNumberOfSectionsInTableViewShouldAlwaysBeOne() {
        // Given
        let tableView = sut.tableViewOutlet
        
        // When
        let numberOfSections = sut.numberOfSections(in: tableView!)
        
        // Then
        XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
    }
    
    func testTableViewReloadOnPresentFetchedDictionary() {
        // Given
        let tableViewSpy = TableViewSpy()
        sut.tableViewOutlet = tableViewSpy
        
        // When
        sut.presentFetchedDirectory(viewModel: directoryViewModel)
        
        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched orders should reload the table view")
    }
    
    func testTableViewRowsOnPresentFetchedDictionary() {
       
        sut.presentFetchedDirectory(viewModel: directoryViewModel)
        
        let numberOfRows = sut.tableView(sut.tableViewOutlet, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, 1, "Error in number of rows")
    }
    
    // TODO func displayFetchDirectoryFetchError(viewModel: DirectoryViewModel)
   
    // displayPage should be called when selected
    func testDisplayPageCallWhenRowSelected() {
        // Given
        let tableView = sut.tableViewOutlet
        
        // When
        let indexPath = IndexPath(row: 0, section: 1)
        
        sut.tableView(tableView!, didSelectRowAt: indexPath)
        
        // Then
        XCTAssert(spy.displaySelectedPageCalled, "output didSelectRow not called")
    }
    
    func testSearchBarSeeksUpdate() {
        let searchBar = sut.searchBarOutlet
        
        let searchText = "anything"
        
        sut.searchBar(searchBar!, textDidChange: searchText)
        
        XCTAssert(spy.filterDirectoryToCalled, "search bar not working")
    }
    
    func testSearchBarDisappearsOnScroll() {
        
    }
    
    
    func testChangeToLeftTabOnSwipe() {

        sut.rightSwipeGesture(self)
        
        XCTAssert(spy.changeToNextTabLeftCalled, "Swipe right didn't hit output")
        
    }
}
