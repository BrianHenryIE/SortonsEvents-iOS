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

    let listEventsView: ListEventsTableViewController!
    var rootViewController: RootViewControllerProtocol?

    init(fomoId: FomoId) {
        let storyboard = UIStoryboard(name: "ListEvents", bundle: Bundle.main)

        listEventsView = storyboard.instantiateViewController(withIdentifier: "ListEvents") as? ListEventsTableViewController

        let listEventsPresenter = ListEventsPresenter(output: listEventsView)

        let listEventsInteractor = ListEventsInteractor(wireframe: self,
                                                        fomoId: fomoId.id,
                                                        output: listEventsPresenter,
                                                        listEventsNetworkWorker: ListEventsNetworkWorker(),
                                                        listEventsCacheWorker: ListEventsCacheWorker())

        listEventsView.output = listEventsInteractor
    }

    func changeToNextTabRight() {
        
        rootViewController?.changeToNextTabRight()
        
    }
}
