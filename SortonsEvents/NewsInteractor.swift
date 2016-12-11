//
//  NewsViewInteractor.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import WebKit

class NewsInteractor: NewsViewControllerOutput {

    let wireframe: NewsWireframe
    let fomoId: String
    let output: NewsInteractorOutput

    init(wireframe: NewsWireframe, fomoId: String, output: NewsInteractorOutput) {
        self.wireframe = wireframe
        self.fomoId = fomoId
        self.output = output
    }

    func open(_ url: URL) {

        let urlString = url.absoluteString

        let facebookUrl = FacebookUrl(from: urlString)

        wireframe.openUrl(facebookUrl)
    }

    func setup(_ request: News.Fetch.Request) {
        output.setFomoId(fomoId)
    }

    func changeToNextTabLeft() {
        wireframe.changeToNextTabLeft()
    }

    func changeToNextTabRight() {
        wireframe.changeToNextTabRight()
    }
}
