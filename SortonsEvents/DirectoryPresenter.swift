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
    
    init(output: DirectoryPresenterOutput) {
        self.output = output
    }
    
    func presentFetchedDirectory(_ directory: Directory.Fetch.Response) {
        
        let viewModelDirectory = directory.directory.map({
            Directory.TableViewCellModel(name: $0.name, details: $0.friendlyLocationString, imageUrl: URL(string: "https://graph.facebook.com/\($0.fbPageId!)/picture?type=square")!)
        })
        
        let viewModel = Directory.ViewModel(directory: viewModelDirectory)
        
        output?.presentFetchedDirectory(viewModel)
    }
}
