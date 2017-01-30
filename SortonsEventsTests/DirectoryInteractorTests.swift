//
//  DirectoryInteractorTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest
import ObjectMapper
import Alamofire

// This is easier in Java!
fileprivate class PresenterSpy: DirectoryInteractorOutputProtocol {

    var presentFetchedDirectoryCalled = 0
    var sourcePagesCount = 0

    func presentFetchedDirectory(_ directory: Directory.Fetch.Response) {
        presentFetchedDirectoryCalled += 1
        sourcePagesCount = directory.directory.count
    }
}

fileprivate class CacheSpy<T: ImmutableMappable>: CacheProtocol {

    var fetchCalled = false
    var saveCalled = false

    let bundle: Bundle

    init(with bundle: Bundle) {
        self.bundle = bundle
    }

    func fetch<T: ImmutableMappable>() -> [T]? {
        fetchCalled = true

        guard let path = bundle.path(forResource: "DirectoryInteractorTestsDummyData",
                                          ofType: "json"),
            let content = try? String(contentsOfFile: path),
            let cacheDummyPages = try? Mapper<T>().mapArray(JSONString: content) else {
                return nil
        }

        return cacheDummyPages
    }

    func save<T: ImmutableMappable>(_ latestData: [T]?) {
        saveCalled = true
    }
}

fileprivate class NetworkSpy<T: SortonsNW & ImmutableMappable>: NetworkProtocol {
    var fetchCalled = false

    let bundle: Bundle

    init(with bundle: Bundle) {
        self.bundle = bundle
    }

    func fetch<T: SortonsNW & ImmutableMappable>
        (_ fomoId: String,
         completionHandler: @escaping (_ result: Result<[T]>) -> Void) {
        fetchCalled = true

        guard let path = bundle.path(forResource: "DirectoryInteractorTestsDummyData",
                                          ofType: "json"),
            let content = try? String(contentsOfFile: path),
            let networkDummyPages = try? Mapper<T>().mapArray(JSONString: content) else {
            XCTFail()
            return
        }

        completionHandler(Result<[T]>.success(networkDummyPages))
    }
}

class DirectoryInteractorTests: XCTestCase {

    var sut: DirectoryInteractor!

    fileprivate var presenterSpy: PresenterSpy!
    fileprivate var cacheSpy: CacheSpy<SourcePage>!
    fileprivate var networkSpy: NetworkSpy<SourcePage>!

    let fomoId = FomoId(fomoIdNumber: "id",
                                name: "name",
                           shortName: "shortName",
                            longName: "longName",
                          appStoreId: "appStoreId",
                              censor: [String]())

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: self.classForCoder)

        presenterSpy = PresenterSpy()
        cacheSpy = CacheSpy<SourcePage>(with: bundle)
        networkSpy = NetworkSpy<SourcePage>(with: bundle)

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

        XCTAssert(networkSpy.fetchCalled, "Network worker not called by Interactor")

        XCTAssertEqual(self.presenterSpy.presentFetchedDirectoryCalled, 2,
                       "Directory Presenter not called after cache, network Worker")
        XCTAssert(self.cacheSpy.saveCalled, "New events not saved to cache")

    }

    func testFilterDirectoryTo() {
        // should save filter to variable in case cache is searched then overwritten by network

        // let it request data from the other spies!
        let request = Directory.Request()
        sut.fetchDirectory(request)

        sut.filterDirectoryTo("music")

        XCTAssertEqual(4, presenterSpy.sourcePagesCount, "Post filter count incorrect")
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
