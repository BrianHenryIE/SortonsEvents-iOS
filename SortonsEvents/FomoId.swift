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
    init?() {
        if let fomoIdNumber = Bundle.main.infoDictionary?["FomoId"] as? String,
            let name = Bundle.main.infoDictionary?["FomoName"] as? String,
            let shortName = Bundle.main.infoDictionary?["ShortName"] as? String,
            let longName = Bundle.main.infoDictionary?["LongName"] as? String,
            let appStoreId = Bundle.main.infoDictionary?["AppStoreId"] as? String,
            let censor = Bundle.main.infoDictionary?["FomoCensor"] as? [String] {

            self.fomoIdNumber = fomoIdNumber
            self.name = name
            self.shortName = shortName
            self.longName = longName
            self.appStoreId = appStoreId
            self.censor = censor
        } else {
            return nil
        }
    }
}
