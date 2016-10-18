//
//  DirectoryViewControllerIO.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

// View input
protocol DirectoryPresenterOutput {
    func presentFetchedDirectory(viewModel: DirectoryViewModel)
    
    func displayFetchDirectoryFetchError(viewModel: DirectoryViewModel)
}

protocol DirectoryViewControllerOutput {
    func fetchDirectory(withRequest: Directory_FetchDirectory_Request)
    
    func filterDirectoryTo(searchBarInput: String)
    
    func displaySelectedPageFrom(rowNumber: Int)
}
