//
//  RootViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 24/08/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    // This instead? : https://makeapppie.com/2014/09/09/swift-swift-using-tab-bar-controllers-in-swift/
    
    let fomoId = "428055040731753"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Instantiate and add the modules, display events (or a preference, or last used!)
        NSLog("action")
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        let listEventsWireframe = ListEventsWireframe(fomoId: fomoId)
        let listEventsView = listEventsWireframe.listEventsView!
        
        
        let directoryWireframe = DirectoryWireframe(fomoId: fomoId)
        let directoryViewController = directoryWireframe.directoryView!
        
        viewControllers = [listEventsView, directoryViewController]
        
//        self.present(directoryViewController, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any views not in the foreground
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
