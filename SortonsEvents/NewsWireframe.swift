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

    let newsView: NewsViewController!
    var rootViewController : RootViewControllerProtocol?

    init(fomoId: FomoId) {
        let storyboard = UIStoryboard(name: "News", bundle: Bundle.main)
        
        newsView = storyboard.instantiateViewController(withIdentifier: "News") as? NewsViewController
      
        let newsPresenter = NewsPresenter(output: newsView!)
        
        let newsInteractor = NewsInteractor(wireframe: self, fomoId: fomoId.id, output: newsPresenter)
    
        newsView.output = newsInteractor
    }

    func changeToNextTabLeft() {
        if let rootViewController = rootViewController {
            rootViewController.changeToNextTabLeft()
        }
    }

    func changeToNextTabRight() {
        if let rootViewController = rootViewController {
            rootViewController.changeToNextTabRight()
        }
    }
}
