//
//  GAEISO8601DateTransform.swift
//  SortonsEvents
//
//  Created by Brian Henry on 30/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

open class GAEISO8601DateTransform: DateFormatterTransform {

    public init() {
        let formatter = DateFormatter()

        // Not sure if this line is needed - copied from proper 8601
        formatter.locale = Locale(identifier: "en_US_POSIX")

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        super.init(dateFormatter: formatter)
    }

}
