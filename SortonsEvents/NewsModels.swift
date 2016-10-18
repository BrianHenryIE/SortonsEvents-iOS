//
//  NewsModels.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

struct News {
    struct Fetch {
        struct Request {}
        struct Response {
            let fomoId: String
        }
    }
    struct ViewModel {
        let newsUrl: URLRequest
    }
}
