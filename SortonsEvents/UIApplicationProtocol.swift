//
//  UIApplicationProtocol.swift
//  SortonsEvents
//
//  Created by Brian Henry on 4/2/17.
//  Copyright © 2017 Sortons. All rights reserved.
//
//  For testing

//import Foundation
import UIKit

protocol UIApplicationProtocol {

    func canOpenURL(_ url: URL) -> Bool

    func open(_ url: URL,
              options: [String : Any],
              completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplication: UIApplicationProtocol {}
