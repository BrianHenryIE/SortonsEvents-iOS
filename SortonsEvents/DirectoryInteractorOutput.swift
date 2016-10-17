//
//  DirectoryInteractorOutput.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

protocol DirectoryInteractorOutput {
    
    func presentFetchedDirectory(directory: Directory_FetchDirectory_Response)
}
