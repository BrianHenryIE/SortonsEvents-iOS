//
//  DirectoryPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

extension Directory {
    struct ViewModel {
        let directory: [Directory.TableViewCellModel]
    }

    struct TableViewCellModel {
        let name: String
        let details: String?
        let imageUrl: URL
    }
}

protocol DirectoryPresenterOutputProtocol {

    func presentFetchedDirectory(_ viewModel: Directory.ViewModel)

    func displayFetchDirectoryFetchError(_ viewModel: Directory.ViewModel)
}

class DirectoryPresenter: DirectoryInteractorOutputProtocol {

    var output: DirectoryPresenterOutputProtocol?
    let fomoCensor: [String]

    init(output: DirectoryPresenterOutputProtocol?, fomoCensor: [String] = [String]()) {
        self.output = output
        self.fomoCensor = fomoCensor
    }

    func presentFetchedDirectory(_ directory: Directory.Fetch.Response) {

        let viewModelDirectory = directory.directory.map({ (sourcePage) -> Directory.TableViewCellModel in
            var name = sourcePage.name
            // Remove references to the college so Apple doesn't say we're pretending to be them
            if TARGET_IPHONE_SIMULATOR == 1 {
                for censor in fomoCensor {
                    name = name.replacingOccurrences(of: "\(censor) ", with: "", options: .literal, range: nil)
                    name = name.replacingOccurrences(of: censor, with: "", options: .literal, range: nil)
                }
            }
            let details = sourcePage.friendlyLocationString
            let imageUrl = URL(string: "https://graph.facebook.com/\(sourcePage.fbPageId)/picture?type=square")!
            return Directory.TableViewCellModel(name: name,
                                             details: details,
                                            imageUrl: imageUrl)
        })

        let viewModel = Directory.ViewModel(directory: viewModelDirectory)

        DispatchQueue.main.async {
            self.output?.presentFetchedDirectory(viewModel)
        }
    }
}
