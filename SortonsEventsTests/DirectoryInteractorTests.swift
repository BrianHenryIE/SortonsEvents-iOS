//
//  DirectoryInteractorTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

// This is easier in Java!
fileprivate class PresenterSpy: DirectoryInteractorOutputProtocol {

    var presentFetchedDirectoryCalled = 0
    var sourcePagesCount = 0

    func presentFetchedDirectory(_ directory: Directory.Fetch.Response) {
        presentFetchedDirectoryCalled += 1
        sourcePagesCount = directory.directory.count
    }
}

fileprivate class CacheSpy: DirectoryCacheProtocol {

    var fetchCalled = false
    var saveCalled = false

    func fetch() -> String? {
        fetchCalled = true

        let bundle = Bundle(for: CacheSpy.self)
        guard let path = bundle.path(forResource: "ClientPageDataTcd", ofType: "json"),
            let content = try? String(contentsOfFile: path) else {
                return nil
        }

        return content
    }

    func save(_ latestClientPageData: String) {
        saveCalled = true
    }
}

fileprivate class NetworkSpy: DirectoryNetworkProtocol {
    var fetchCalled = false

    func fetchDirectory(_ fomoId: String, completionHandler: @escaping (_ discoveredEventsJsonPage: String) -> Void) {
        fetchCalled = true

        let bundle = Bundle(for: NetworkSpy.self)
        let path = bundle.path(forResource: "ClientPageDataTcd", ofType: "json")!

        guard let content = try? String(contentsOfFile: path) else {
            XCTFail()
            return
        }

        completionHandler(content)
    }
}

class DirectoryInteractorTests: XCTestCase {

    var sut: DirectoryInteractor!

    fileprivate var presenterSpy: PresenterSpy!
    fileprivate var cacheSpy: CacheSpy!
    fileprivate var networkSpy: NetworkSpy!

    let fomoId = FomoId(fomoIdNumber: "id",
                                name: "name",
                           shortName: "shortName",
                            longName: "longName",
                          appStoreId: "appStoreId", censor: [String]())

    override func setUp() {
        super.setUp()

        presenterSpy = PresenterSpy()
        cacheSpy = CacheSpy()
        networkSpy = NetworkSpy()

        sut = DirectoryInteractor(fomoIdNumber: fomoId.fomoIdNumber,
                                     wireframe: DirectoryWireframe(fomoId: fomoId),
                                     presenter: presenterSpy,
                                         cache: cacheSpy,
                                       network: networkSpy)
    }

    func testFetchDirectory() {
        // Should hit the cache, save to variable, send to presenter, 
        // then hit the network, save to variable, send to presenter
        let request = Directory.Request()

        sut.fetchDirectory(request)

        XCTAssert(cacheSpy.fetchCalled, "Cache worker not called by Interactor")
        // Actually is being called but assessing too late
//        XCTAssertEqual(presenterSpy.presentFetchedDirectoryCalled, 1, "Directory presenter not called after cache")

        XCTAssert(networkSpy.fetchCalled, "Network worker not called by Interactor")

        XCTAssertEqual(self.presenterSpy.presentFetchedDirectoryCalled, 2,
                       "Directory Presenter not called after Network Worker")
        XCTAssert(self.cacheSpy.saveCalled, "New events not saved to cache")

    }

    func testFilterDirectoryTo() {
        // should save filter to variable in case cache is searched then overwritten by network

        // let it request data from the other spies!
        let request = Directory.Request()
        sut.fetchDirectory(request)

        sut.filterDirectoryTo("music")

        XCTAssertEqual(6, presenterSpy.sourcePagesCount, "Post filter count incorrect")
    }

    func displaySelectedPageFrom(rowNumber: Int) {
        // should launch facebook app if available, otherwise safari

        // let it request data from the other spies!
//        let request = Directory_FetchDirectory_Request()
//        sut.fetchDirectory(withRequest: request)
//
//        sut.filterDirectoryTo(searchBarInput: "music")
//
//        sut.displaySelectedPageFrom(rowNumber: 3)

        // Not sure how to test called to UIApplication

    }
}
