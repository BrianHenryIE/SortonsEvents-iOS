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

    var rootViewController: UIViewController? {
        didSet {
            metaMainView?.rootViewController = self.rootViewController
        }
    }
    let storyboard = UIStoryboard(name: "Meta", bundle: Bundle.main)

    var metaNavigationView: UIViewController?
    var metaMainView: MetaViewController?
    var metaInteractor: MetaInteractor?

    init(fomoId: FomoId) {
        self.fomoId = fomoId
        super.init()
        presentMainView()
    }

    func presentMainView() {

        // also defined in rootview controller?!
        guard let metaMainView = storyboard.instantiateViewController(withIdentifier: "Meta")
            as? MetaViewController else {
            return
        }

        self.metaMainView = metaMainView

        metaNavigationView = UINavigationController(rootViewController: metaMainView)

        let metaPresenter = MetaPresenter(fomoId: fomoId,
                                          output: metaMainView)

        metaInteractor = MetaInteractor(wireframe: self,
                                           fomoId: fomoId,
                                        presenter: metaPresenter)

        metaMainView.output = metaInteractor
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

        metaNavigationView?.childViewControllers[0].navigationController?.pushViewController(metaWebViewController,
                                                                                  animated: true)
    }

    func openIosSettings() {
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }

    func reviewOnAppStore(_ link: String) {
        UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
    }
}
