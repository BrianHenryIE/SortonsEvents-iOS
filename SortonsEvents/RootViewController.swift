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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Instantiate and add the modules, display events (or a preference, or last used!)
        NSLog("action")
        
        let fomoId = "428055040731753"
       
//        
//        let listEventsWireframe = ListEventsWireframe(fomoId: fomoId)
//        let listEventsView = listEventsWireframe.listEventsView
//        
//        viewControllers!.append(listEventsView)
//        
//        self.presentViewController(listEventsView, animated: true, completion: nil)
//       
        
        let directoryWireframe = DirectoryWireframe(fomoId: fomoId)
        let directoryViewController = directoryWireframe.directoryView
        
        viewControllers!.append(directoryViewController)
        
        self.presentViewController(directoryViewController, animated: true, completion: nil)
        
        

        
        
        
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
