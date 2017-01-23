//
//  DirectoryInteractor.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

struct Directory {
    struct Fetch {
        struct Response {
            let directory: [SourcePage]
        }
    }
}

protocol DirectoryInteractorOutputProtocol {
    func presentFetchedDirectory(_ directory: Directory.Fetch.Response)

}

class DirectoryInteractor: DirectoryViewControllerOutputProtocol {

    var wireframe: DirectoryWireframe

    var directory = [SourcePage]()
    var displayedDirectory = [SourcePage]()
    var currentFilter = ""

    var fomoIdNumber: String
    var output: DirectoryInteractorOutputProtocol!

    var cacheWorker: CacheProtocol
    let networkWorker: NetworkProtocol

    init(fomoIdNumber: String,
            wireframe: DirectoryWireframe,
            presenter: DirectoryInteractorOutputProtocol,
                cache: CacheProtocol,
              network: NetworkProtocol) {
        self.fomoIdNumber = fomoIdNumber
        self.wireframe = wireframe
        output = presenter
        cacheWorker = cache
        networkWorker = network
    }

    func fetchDirectory(_ withRequest: Directory.Request) {

        if let directoryFromCache: [SourcePage] = cacheWorker.fetch() {

            directory = directoryFromCache
            self.outputDirectoryToPresenter()
        }

        networkWorker.fetch(fomoIdNumber) {(result: Result<[SourcePage]>) -> Void in
            switch result {
            case .success(let sourcePages):
                self.directory = sourcePages
                self.cacheWorker.save(sourcePages)
                self.outputDirectoryToPresenter()
            case .failure(let error):
                break
            }
        }
    }

    func filterDirectoryTo(_ searchBarInput: String) {
        currentFilter = searchBarInput.lowercased()
        outputDirectoryToPresenter()
    }

    fileprivate func outputDirectoryToPresenter() {
        // filter directory using currentfilter and save to displayedDirectory

        if currentFilter.trimmingCharacters(in: CharacterSet.whitespaces) != "" {
                displayedDirectory = directory.filter({
                    ($0.name.lowercased()).contains(currentFilter)
                })
        } else {
            displayedDirectory = directory
        }

        let response = Directory.Fetch.Response(directory: displayedDirectory)
        self.output.presentFetchedDirectory(response)
    }

    func displaySelectedPageFrom(_ rowNumber: Int) {

        let fbId = displayedDirectory[rowNumber].fbPageId

        let appUrl = URL(string: "fb://profile/\(fbId)")!
        let safariUrl = URL(string: "https://facebook.com/\(fbId)")!

        if UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.openURL(appUrl)
        } else {
            UIApplication.shared.openURL(safariUrl)
        }
    }
}
