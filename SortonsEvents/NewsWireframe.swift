//
//  NewsWireframe.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import Foundation

class NewsWireframe {

    let newsView: NewsViewController?

    init(fomoId: FomoId) {
        let storyboard = UIStoryboard(name: "News", bundle: Bundle.main)

        newsView = storyboard.instantiateViewController(withIdentifier: "News") as? NewsViewController

        let newsPresenter = NewsPresenter(output: newsView)

        let newsInteractor = NewsInteractor(wireframe: self,
                                               fomoId: fomoId.fomoIdNumber,
                                               output: newsPresenter)

        newsView?.output = newsInteractor
    }

    func openUrl(_ url: FacebookUrl) {
        if let appUrl = url.appUrl, UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
            return
        }
        UIApplication.shared.open(url.safariUrl, options: [:], completionHandler: nil)
    }
}
