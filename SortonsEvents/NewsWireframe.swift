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
    
    init(fomoId: String) {
        
        let storyboard = UIStoryboard(name: "News", bundle: Bundle.main)
        
        newsView = storyboard.instantiateViewController(withIdentifier: "News") as! NewsViewController
        
    }
    
}
