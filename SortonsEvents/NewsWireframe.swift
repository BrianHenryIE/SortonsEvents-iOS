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
    let rootViewController : RootViewControllerProtocol
    
    init(rootViewController: RootViewControllerProtocol, fomoId: String) {
        self.rootViewController = rootViewController
        
        let storyboard = UIStoryboard(name: "News", bundle: Bundle.main)
        
        newsView = storyboard.instantiateViewController(withIdentifier: "News") as! NewsViewController
      
        let newsPresenter = NewsPresenter(output: newsView)
        
        let newsInteractor = NewsInteractor(wireframe: self, fomoId: fomoId, output: newsPresenter)
        
        newsView.output = newsInteractor
    }
    
    func changeToNextTabLeft() {
        rootViewController.changeToNextTabLeft()
    }
    
    func changeToNextTabRight() {
        rootViewController.changeToNextTabRight()
    }
}
