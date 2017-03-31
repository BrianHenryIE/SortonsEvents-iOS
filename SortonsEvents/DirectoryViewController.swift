//
//  DirectoryViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit

extension Directory {
    struct Request {}
}

protocol DirectoryViewControllerOutputProtocol {
    func fetchDirectory(_ withRequest: Directory.Request)

    func filterDirectoryTo(_ searchBarInput: String)

    func displaySelectedPageFrom(_ rowNumber: Int)
}

class DirectoryViewController: UIViewController, DirectoryPresenterOutputProtocol {

    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!

    var output: DirectoryViewControllerOutputProtocol?
    var data: [Directory.TableViewCellModel]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        tableViewOutlet.estimatedRowHeight = 80

        let gestureRecognizer = UIGestureRecognizer()
        gestureRecognizer.cancelsTouchesInView = false
        tableViewOutlet.addGestureRecognizer(gestureRecognizer)

        gestureRecognizer.delegate = self

        let top = UIApplication.shared.statusBarFrame.size.height
        tableViewOutlet.contentInset = UIEdgeInsets(top: top,
                                                   left: 0,
                                                 bottom: 49,
                                                  right: 0)

        tableViewOutlet.setContentOffset(CGPoint(x: 0, y: top * -1), animated: false)

        let request = Directory.Request()
        output?.fetchDirectory(request)
    }

// MARK: DirectoryPresenterOutput

    func presentFetchedDirectory(_ viewModel: Directory.ViewModel) {
        data = viewModel.directory
        tableViewOutlet.reloadData()
    }

    func displayFetchDirectoryFetchError(_ viewModel: Directory.ViewModel) {

    }

    // MARK: UISearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output?.filterDirectoryTo(searchText)
    }
}

extension DirectoryViewController: UITableViewDataSource, UITableViewDelegate {
// MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sourcePage = data?[indexPath.row] else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryPageCell",
                                                            for: indexPath) as? DirectoryTableViewCell
        cell?.setDirectorySourcePage(sourcePage)

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        output?.displaySelectedPageFrom(row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DirectoryViewController: UIGestureRecognizerDelegate {
// MARK: UIGestureRecogniserDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        searchBarOutlet.resignFirstResponder()

        return false
    }
}
