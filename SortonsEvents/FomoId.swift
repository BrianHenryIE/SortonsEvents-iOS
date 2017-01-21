//
//  FomoId.swift
//  SortonsEvents
//
//  Created by Brian Henry on 03/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

struct FomoId {

    let fomoIdNumber: String
    let name: String
    let shortName: String
    let longName: String
    let appStoreId: String
    let censor: [String]
}

extension FomoId {
    init() {
        // TODO Change to failable initializer and handle in AppDelegate
        // swiftlint:disable force_cast
        fomoIdNumber = Bundle.main.infoDictionary?["FomoId"] as! String
        name = Bundle.main.infoDictionary?["FomoName"] as! String
        shortName = Bundle.main.infoDictionary?["ShortName"] as! String
        longName = Bundle.main.infoDictionary?["LongName"] as! String
        appStoreId = Bundle.main.infoDictionary?["AppStoreId"] as! String
        censor = Bundle.main.infoDictionary?["FomoCensor"] as! [String]
    }
}
