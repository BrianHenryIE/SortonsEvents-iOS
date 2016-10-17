//
//  DirectoryModels.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

struct Directory_FetchDirectory_Request {
}

struct Directory_FetchDirectorys_Response {
    let directory: [ClientPageData]
}

struct DirectoryViewModel {
    let directory: [DirectoryTableViewCellModel]
}

struct DirectoryTableViewCellModel {
    let name: String
    let details: String?
    let imageUrl: URL
}
