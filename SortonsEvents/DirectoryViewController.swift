//
//  DirectoryViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

class DirectoryViewController: UIViewController, DirectoryPresenterOutput, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var output: DirectoryViewControllerOutput!
    var data: [DirectoryTableViewCellModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = Directory_FetchDirectory_Request()
        output.fetchDirectory(withRequest: request)
    }

// MARK: DirectoryPresenterOutput
    func presentFetchedDirectory(viewModel: DirectoryViewModel) {
        data = viewModel.directory
        tableViewOutlet.reloadData()
    }
    
    func displayFetchDirectoryFetchError(viewModel: DirectoryViewModel) {
        
    }
    
// MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return data!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sourcePage = data?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryPageCell", for: indexPath) as! DirectoryTableViewCell
        cell.setDirectorySourcePage(directoryPage: sourcePage!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.displaySelectedPageFrom(rowNumber: indexPath.row)
    }
    
    // MARK: UISearchBar    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output.filterDirectoryTo(searchBarInput: searchText)
    }
    
}
