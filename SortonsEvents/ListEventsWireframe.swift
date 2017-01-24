//
//  ListEventsWireframe.swift
//  SortonsEvents
//
//  Created by Brian Henry on 24/08/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import Foundation

class ListEventsWireframe {

    let listEventsView: ListEventsTableViewController?

    init(fomoId: FomoId) {
        let storyboard = UIStoryboard(name: "ListEvents", bundle: Bundle.main)

        listEventsView = storyboard.instantiateViewController(withIdentifier: "ListEvents")
            as? ListEventsTableViewController

        let listEventsPresenter = ListEventsPresenter(output: listEventsView)

        let networkWorker = NetworkWorker<DiscoveredEvent>()
        let cacheWorker = CacheWorker<DiscoveredEvent>()

        let listEventsInteractor = ListEventsInteractor(wireframe: self,
                                                           fomoId: fomoId.fomoIdNumber,
                                                           output: listEventsPresenter,
                                          listEventsNetworkWorker: networkWorker,
                                            listEventsCacheWorker: cacheWorker)

        listEventsView?.output = listEventsInteractor
    }
}
