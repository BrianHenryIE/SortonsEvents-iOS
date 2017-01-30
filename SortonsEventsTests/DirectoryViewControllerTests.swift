//
//  DirectoryViewControllerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

fileprivate class TableViewSpy: UITableView {
    // MARK: Method call expectations
    var reloadDataCalled = false

    // MARK: Spied methods
    override func reloadData() {
        reloadDataCalled = true
    }
}
fileprivate class OutputSpy: DirectoryViewControllerOutputProtocol {

    // MARK: Method call expectations
    var fetchDirectoryCalled = false
    var filterDirectoryToCalled = false
    var displaySelectedPageCalled = false
    var changeToNextTabLeftCalled = false

    func fetchDirectory(_ withRequest: Directory.Request) {

        fetchDirectoryCalled = true
    }

    func filterDirectoryTo(_ searchBarInput: String) {
        filterDirectoryToCalled = true
    }

    func displaySelectedPageFrom(_ rowNumber: Int) {
        displaySelectedPageCalled = true
    }

    func changeToNextTabLeft() {
        changeToNextTabLeftCalled = true
    }
}

class DirectoryViewControllerTests: XCTestCase {

    var sut: DirectoryViewController!
    fileprivate let outputSpy = OutputSpy()
    var directoryViewModel: Directory.ViewModel!

    override func setUp() {
        super.setUp()

        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Directory", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "Directory") as? DirectoryViewController

        sut.output = outputSpy

        // Call viewDidLoad()
        let _ = sut.view

        let sampleImageUrl: URL = URL(string: "https://graph.facebook.com/206961869324550/picture?type=square")!
        let sampleDirectoryEntry = Directory.TableViewCellModel(name: "test entry",
                                                             details: "no details",
                                                            imageUrl: sampleImageUrl)
        let sampleDirectoryModel = [sampleDirectoryEntry]
        directoryViewModel = Directory.ViewModel(directory: sampleDirectoryModel)
    }

    func testViewDidLoadShouldCallFetchDirectory() {
        XCTAssert(outputSpy.fetchDirectoryCalled, "View not initializing as expected – should fetch directory on load")
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
        sut.presentFetchedDirectory(directoryViewModel)

        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched orders should reload the table view")
    }

    func testTableViewRowsOnPresentFetchedDictionary() {

        sut.presentFetchedDirectory(directoryViewModel)

        let numberOfRows = sut.tableView(sut.tableViewOutlet, numberOfRowsInSection: 0)

        XCTAssertEqual(numberOfRows, 1, "Error in number of rows")
    }

    // displayPage should be called when selected
    func testDisplayPageCallWhenRowSelected() {
        // Given
        let tableView = sut.tableViewOutlet

        // When
        let indexPath = IndexPath(row: 0, section: 1)

        sut.tableView(tableView!, didSelectRowAt: indexPath)

        // Then
        XCTAssert(outputSpy.displaySelectedPageCalled, "output didSelectRow not called")
    }

    func testSearchBarSeeksUpdate() {
        let searchBar = sut.searchBarOutlet

        let searchText = "anything"

        sut.searchBar(searchBar!, textDidChange: searchText)

        XCTAssert(outputSpy.filterDirectoryToCalled, "search bar not working")
    }

    func testSearchBarDisappearsOnScroll() {

    }
}
