//
//  FomoId.swift
//  SortonsEvents
//
//  Created by Brian Henry on 03/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

class FomoId: NSObject {

    class func numberFromBundle(bundleName : String) -> String? {
        
        // fomo.plist
        // root/clientpages/ucd
        
        if let path = Bundle.main.path(forResource: "fomo", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            let clientPages : [String: String] = dict["clientpages"] as! [String: String]

            let tlaArray = bundleName.characters.split{$0 == "."}.map(String.init)
            
            let tla = tlaArray[3]
            
            return clientPages[tla]!
            
        }
        
        return nil
    }
    
}
