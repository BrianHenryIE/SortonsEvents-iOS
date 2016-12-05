//
//  FomoId.swift
//  SortonsEvents
//
//  Created by Brian Henry on 03/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

struct FomoId {

    let id: String!
    let name: String!
    let shortName: String!
    let appStoreId: String!

    init() {
        // swiftlint:disable force_cast
        id = Bundle.main.infoDictionary?["FomoId"] as? String
        name = Bundle.main.infoDictionary?["FomoName"] as? String
        shortName = Bundle.main.infoDictionary?["ShortName"] as? String
        appStoreId = Bundle.main.infoDictionary?["AppStoreId"] as? String
    }

    // for testing
    init(id: String, name: String, shortName: String, appStoreId: String) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.appStoreId = appStoreId
    }
}
