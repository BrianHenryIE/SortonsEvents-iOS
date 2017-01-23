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

    let directoryView: DirectoryViewController!

    init(fomoId: FomoId) {
        let storyboard = UIStoryboard(name: "Directory", bundle: Bundle.main)

        directoryView = storyboard.instantiateViewController(withIdentifier: "Directory") as? DirectoryViewController

        let directoryPresenter = DirectoryPresenter(output: directoryView, fomoCensor: fomoId.censor)

        let directoryCacheWorker = CacheWorker<ClientPageData>()
        let directoryNetworkWorker = DirectoryNetworkWorker()

        let directoryInteractor = DirectoryInteractor(fomoIdNumber: fomoId.fomoIdNumber,
                                                         wireframe: self,
                                                         presenter: directoryPresenter,
                                                             cache: directoryCacheWorker,
                                                           network: directoryNetworkWorker)

        directoryView.output = directoryInteractor
    }
}
