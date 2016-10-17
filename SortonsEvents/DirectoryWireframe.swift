//
//  DirectoryWireframe.swift
//  SortonsEvents
//
//  Created by Brian Henry on 24/08/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import Foundation

class DirectoryWireframe {
    
//    let directoryView : ListEventsTableViewController!
    let directoryView: DirectoryViewController!
    
    init(fomoId: String) {
        
        let storyboard = UIStoryboard(name: "Directory", bundle: Bundle.main)
        
        directoryView = storyboard.instantiateViewController(withIdentifier: "Directory") as! DirectoryViewController
        
        let directoryPresenter = DirectoryPresenter(output: directoryView)
        
        let directoryCacheWorker = DirectoryCacheWorker()
        let directoryNetworkWorker = DirectoryNetworkWorker()
        
        let directoryInteractor = DirectoryInteractor(fomoId: fomoId, presenter: directoryPresenter, cache: directoryCacheWorker, network: directoryNetworkWorker)
        
        directoryView.output = directoryInteractor

    }
    
}
