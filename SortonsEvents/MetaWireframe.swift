//
//  NewsWireframe.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class MetaWireframe: NSObject {

    let fomoId: FomoId

    let storyboard = UIStoryboard(name: "Meta", bundle: Bundle.main)

    let metaView: UINavigationController

    init(fomoId: FomoId) {
        self.fomoId = fomoId
        metaView = UINavigationController()
        super.init()

        presentMainView()
    }

    func presentMainView() {

        // also defined in rootview controller?!
        guard let metaMainView = storyboard.instantiateViewController(withIdentifier: "Meta")
            as? MetaViewController else {
            return
        }

        let metaPresenter = MetaPresenter(fomoId: fomoId,
                                          output: metaMainView)

        let metaInteractor = MetaInteractor(wireframe: self,
                                           fomoId: fomoId,
                                        presenter: metaPresenter)

        metaMainView.output = metaInteractor

        metaView.pushViewController(metaMainView, animated: false)
    }

    func presentWebView(for url: String) {

        let metaWebVC = storyboard.instantiateViewController(withIdentifier: "MetaWebViewController")
            as? MetaWebViewController

        guard let metaWebViewController = metaWebVC else {
            return
        }

        let metaWebViewPresenter = MetaWebViewPresenter(with: metaWebViewController,
                                                      fomoId: fomoId)

        let metaWebViewInteractor = MetaWebViewInteractor(with: metaWebViewPresenter,
                                                           for: url)

        metaWebViewController.output = metaWebViewInteractor

        metaView.pushViewController(metaWebViewController,
                                              animated: true)
    }

    func openIosSettings() {
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }

    func reviewOnAppStore(_ link: String) {
        UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
    }
}
