//
//  FomoId.swift
//  SortonsEvents
//
//  Created by Brian Henry on 03/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

struct FomoId {

    let id: String
    let name: String
    let shortName: String
    let appStoreId: String
    let fomoCensor: [String]
}
extension FomoId {
    init() {
        // swiftlint:disable force_cast
        id = Bundle.main.infoDictionary?["FomoId"] as! String
        name = Bundle.main.infoDictionary?["FomoName"] as! String
        shortName = Bundle.main.infoDictionary?["ShortName"] as! String
        appStoreId = Bundle.main.infoDictionary?["AppStoreId"] as! String
        fomoCensor = Bundle.main.infoDictionary?["FomoCensor"] as! [String]
    }
}
