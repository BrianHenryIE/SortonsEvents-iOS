//
//  DirectoryModels.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

struct Directory {
    struct Fetch {
        struct Request {}
        struct Response {
            let directory: [SourcePage]
        }
    }
    
    struct ViewModel {
        let directory: [Directory.TableViewCellModel]
    }
    
    struct TableViewCellModel {
        let name: String
        let details: String?
        let imageUrl: URL
    }
}
