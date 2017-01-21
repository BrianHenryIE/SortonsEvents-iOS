//
//  NewsViewInteractor.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import WebKit

struct News {
    struct Fetch {
        struct Response {
            let fomoId: String
        }
    }
}

protocol NewsInteractorOutputProtocol {
    func setFomoId(_ fomoIdNumber: String)
}

class NewsInteractor: NewsViewControllerOutputProtocol {

    let wireframe: NewsWireframe
    let fomoId: String
    let output: NewsInteractorOutputProtocol

    init(wireframe: NewsWireframe, fomoId: String, output: NewsInteractorOutputProtocol) {
        self.wireframe = wireframe
        self.fomoId = fomoId
        self.output = output
    }

    func open(_ url: URL) {

        let urlString = url.absoluteString

        let facebookUrl = FacebookUrl(from: urlString)

        wireframe.openUrl(facebookUrl)
    }

    func setup(_ request: News.Request) {
        output.setFomoId(fomoId)
    }
}
