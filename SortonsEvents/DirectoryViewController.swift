//
//  DirectoryViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

class DirectoryViewController: UIViewController, DirectoryPresenterOutput, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!

    var output: DirectoryViewControllerOutput!
    var data: [Directory.TableViewCellModel]!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        tableViewOutlet.estimatedRowHeight = 140

        let gestureRecognizer = UIGestureRecognizer()
        tableViewOutlet.addGestureRecognizer(gestureRecognizer)

        gestureRecognizer.delegate = self

        let request = Directory.Fetch.Request()
        output.fetchDirectory(request)
    }

// MARK: DirectoryPresenterOutput

    func presentFetchedDirectory(_ viewModel: Directory.ViewModel) {
        data = viewModel.directory
        tableViewOutlet.reloadData()
    }

    func displayFetchDirectoryFetchError(_ viewModel: Directory.ViewModel) {

    }

// MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return data == nil ? 0 : data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sourcePage = data[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryPageCell", for: indexPath) as? DirectoryTableViewCell
        cell!.setDirectorySourcePage(sourcePage)
        return cell!

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        output.displaySelectedPageFrom(row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

// MARK: UISearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output.filterDirectoryTo(searchText)
    }

// MARK: UIGestureRecogniserDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        searchBarOutlet.resignFirstResponder()

        return false
    }
}
