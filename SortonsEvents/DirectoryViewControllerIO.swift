//
//  DirectoryViewControllerIO.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import UIKit

// View input
protocol DirectoryPresenterOutput {
    func presentFetchedDirectory(_ viewModel: DirectoryViewModel)

    func displayFetchDirectoryFetchError(_ viewModel: DirectoryViewModel)
}

protocol DirectoryViewControllerOutput {
    func fetchDirectory(_ withRequest: Directory_FetchDirectory_Request)

    func filterDirectoryTo(_ searchBarInput: String)

    func displaySelectedPageFrom(_ rowNumber: Int)

    func changeToNextTabLeft()
}
