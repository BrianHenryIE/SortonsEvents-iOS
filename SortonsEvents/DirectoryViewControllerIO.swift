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
    func presentFetchedDirectory(viewModel: Directory.ViewModel)
    
    func displayFetchDirectoryFetchError(viewModel: Directory.ViewModel)
}

protocol DirectoryViewControllerOutput {
    func fetchDirectory(withRequest: Directory.Fetch.Request)
    
    func filterDirectoryTo(searchBarInput: String)
    
    func displaySelectedPageFrom(rowNumber: Int)
    
    func changeToNextTabLeft()
}
