//
//  DirectoryInteractor.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import ObjectMapper

class DirectoryInteractor: DirectoryViewControllerOutput {

    var wireframe: DirectoryWireframe

    var directory = [SourcePage]()
    var displayedDirectory = [SourcePage]()
    var currentFilter = ""

    var fomoId: String
    var output: DirectoryInteractorOutput!

    var cacheWorker: DirectoryCacheWorkerProtocol!
    var networkWorker: DirectoryNetworkWorkerProtocol!

    init(fomoId: String, wireframe: DirectoryWireframe, presenter: DirectoryInteractorOutput, cache: DirectoryCacheWorkerProtocol, network: DirectoryNetworkWorkerProtocol) {
        self.fomoId = fomoId
        self.wireframe = wireframe
        output = presenter
        cacheWorker = cache
        networkWorker = network
    }

    func fetchDirectory(_ withRequest: Directory.Fetch.Request) {

        if let cacheString = cacheWorker.fetch() {
            let directoryFromCache: ClientPageData = Mapper<ClientPageData>().map(JSONString: cacheString)!
            if let data = directoryFromCache.includedPages {
                directory = data
                self.outputDirectoryToPresenter()
            }
        }

        networkWorker.fetchDirectory(fomoId, completionHandler: {(networkString) -> Void in
            let directoryFromNetwork: ClientPageData = Mapper<ClientPageData>().map(JSONString: networkString)!
            if let data = directoryFromNetwork.includedPages {
                self.directory = data
                self.cacheWorker.save(networkString)
                self.outputDirectoryToPresenter()
            }
        })
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

        let fbId = displayedDirectory[rowNumber].fbPageId!

        let appUrl = URL(string: "fb://profile/\(fbId)")!
        let safariUrl = URL(string: "https://facebook.com/\(fbId)")!

        if UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.openURL(appUrl)
        } else {
            UIApplication.shared.openURL(safariUrl)
        }
    }
}
