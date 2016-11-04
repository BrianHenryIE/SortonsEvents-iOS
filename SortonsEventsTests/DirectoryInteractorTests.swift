//
//  DirectoryInteractorTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

// This is easier in Java!
class DirectoryPresenterSpy: DirectoryInteractorOutput {
    
    var presentFetchedDirectoryCalled = 0
    var sourcePagesCount = 0
    
    func presentFetchedDirectory(directory: Directory_FetchDirectory_Response) {
        presentFetchedDirectoryCalled += 1
        sourcePagesCount = directory.directory.count
    }
}

class DirectoryCacheWorkerSpy: DirectoryCacheWorkerProtocol {
    
    var fetchCalled = false
    var saveCalled = false
    
    func fetch() -> String? {
        fetchCalled = true
        
        let bundle = Bundle(for: DirectoryCacheWorkerSpy.self)
        let path = bundle.path(forResource: "ClientPageDataTcd", ofType: "json")!
        
        var content = ""
        
        do {
            content = try String(contentsOfFile: path)
        } catch {
            // TODO / this will throw an error already when parsing
        }
        
        return content
    }
    
    func save(_ latestClientPageData: String) {
        saveCalled = true
    }
}

class DirectoryNetworkWorkerSpy: DirectoryNetworkWorkerProtocol {
    var fetchCalled = false
    
    func fetchDirectory(_ fomoId: String, completionHandler: @escaping (_ discoveredEventsJsonPage: String) -> Void) {
        fetchCalled = true
        
        let bundle = Bundle(for: DirectoryCacheWorkerSpy.self)
        let path = bundle.path(forResource: "ClientPageDataTcd", ofType: "json")!
        
        var content = ""
        
        do {
            content = try String(contentsOfFile: path)
        } catch {
            // TODO / this will throw an error already when parsing
        }
        completionHandler(content)
    }
}

class DirectoryInteractorTests: XCTestCase {
    
    var sut: DirectoryInteractor!
    
    var presenterSpy: DirectoryPresenterSpy!
    var cacheWorkerSpy: DirectoryCacheWorkerSpy!
    var networkWorkerSpy: DirectoryNetworkWorkerSpy!
    
    override func setUp() {
        super.setUp()
        
        let fomoId = "123"
        
        presenterSpy = DirectoryPresenterSpy()
        cacheWorkerSpy = DirectoryCacheWorkerSpy()
        networkWorkerSpy = DirectoryNetworkWorkerSpy()
        
        sut = DirectoryInteractor(fomoId: fomoId, wireframe: DirectoryWireframe(fomoId: fomoId), presenter: presenterSpy, cache: cacheWorkerSpy, network: networkWorkerSpy)
    }
  
    func testFetchDirectory() {
        // Should hit the cache, save to variable, send to presenter, 
        // then hit the network, save to variable, send to presenter
        let request = Directory_FetchDirectory_Request()
    
        sut.fetchDirectory(withRequest: request)
        
        XCTAssert(cacheWorkerSpy.fetchCalled, "Cache worker not called by Interactor")
        // Actually is being called but assessing too late
//        XCTAssertEqual(presenterSpy.presentFetchedDirectoryCalled, 1, "Directory presenter not called after cache")
        
        XCTAssert(networkWorkerSpy.fetchCalled, "Network worker not called by Interactor")
      
        XCTAssertEqual(self.presenterSpy.presentFetchedDirectoryCalled, 2, "Directory Presenter not called after Network Worker")
        XCTAssert(self.cacheWorkerSpy.saveCalled, "New events not saved to cache")
       
    }
    
    func testFilterDirectoryTo() {
        // should save filter to variable in case cache is searched then overwritten by network

        // let it request data from the other spies!
        let request = Directory_FetchDirectory_Request()
        sut.fetchDirectory(withRequest: request)
        
        sut.filterDirectoryTo(searchBarInput: "music")
        
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
