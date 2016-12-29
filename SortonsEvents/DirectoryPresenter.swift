//
//  DirectoryPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

class DirectoryPresenter: DirectoryInteractorOutput {

    var output: DirectoryPresenterOutput?
    let fomoCensor: [String]

    init(output: DirectoryPresenterOutput, fomoCensor: [String]) {
        self.output = output
        self.fomoCensor = fomoCensor
    }

    func presentFetchedDirectory(_ directory: Directory.Fetch.Response) {

        let viewModelDirectory = directory.directory.map({ (sourcePage) -> Directory.TableViewCellModel in
            var name = sourcePage.name!
            // Remove references to the college so Apple doesn't say we're protrouding to be them
            if TARGET_IPHONE_SIMULATOR == 1 {
                for censor in fomoCensor {
                    name = name.replacingOccurrences(of: "\(censor) ", with: "", options: .literal, range: nil)
                    name = name.replacingOccurrences(of: censor, with: "", options: .literal, range: nil)
                }
            }
            let details = sourcePage.friendlyLocationString!
            let imageUrl = URL(string: "https://graph.facebook.com/\(sourcePage.fbPageId!)/picture?type=square")!
            return Directory.TableViewCellModel(name: name,
                                             details: details,
                                            imageUrl: imageUrl)
        })

        let viewModel = Directory.ViewModel(directory: viewModelDirectory)

        output?.presentFetchedDirectory(viewModel)
    }
}
