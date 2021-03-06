//
//  ListEventsTableViewController.swift
//  SortonsEvents
//
//  Created by Brian Henry on 04/07/2016.
//  Copyright (c) 2016 Sortons. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import DZNEmptyDataSet

protocol ListEventsTableViewControllerOutputProtocol {
    func fetchFromCache()
    func fetchFromNetwork()

    func displayEvent(for rowNumber: Int)
}

class ListEventsTableViewController: UITableViewController, ListEventsPresenterOutputProtocol {

    var output: ListEventsTableViewControllerOutputProtocol?
    var data: [ListEvents.ViewModel.Cell]?

    // MARK: Object lifecycle

// MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        fetchEventsOnLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadNotificationReceived(notification:)),
                                                   name: SortonsNotifications.Reload,
                                                 object: nil)
    }

    func setupViews() {
        // Start content below (not beneath) the status bar
        let top = UIApplication.shared.statusBarFrame.size.height
        self.tableView.contentInset = UIEdgeInsets(top: top,
                                                  left: 0,
                                                bottom: 49,
                                                 right: 0)

        // Autosizing cell heights
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        self.tableView.tableFooterView = UIView()

        refreshControl?.addTarget(self,
                                  action: #selector(refresh(_:)),
                                     for: UIControlEvents.valueChanged)
    }

    func fetchEventsOnLoad() {
        output?.fetchFromCache()
        fetchFromNetwork()
    }

    func fetchFromNetwork() {
        refreshControl?.beginRefreshing()
        tableView.setContentOffset(CGPoint(x: 0, y: -1.2*(refreshControl?.frame.size.height ?? 0)), animated: true)
        output?.fetchFromNetwork()
    }

    func reloadNotificationReceived(notification: NSNotification!) {
        fetchFromNetwork()
    }

    func refresh(_ sender: Any) {
        fetchFromNetwork()
    }

// MARK: Display logic ListEventsPresenterOutput
    func presentFetchedEvents(_ viewData: ListEvents.ViewModel) {

        if let cells = viewData.discoveredEvents {
            self.data = cells
            tableView.reloadData()
        }

        if viewData.hideRefreshControl {
            refreshControl?.endRefreshing()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let topVisibleRow = tableView.indexPathsForVisibleRows?[0]

        coordinator.animate(alongsideTransition: { _ in

            let top = UIApplication.shared.statusBarFrame.size.height
            self.tableView.contentInset = UIEdgeInsets(top: top,
                                                       left: 0,
                                                       bottom: 49,
                                                       right: 0)

        }, completion: { _ in
            if let topVisibleRow = topVisibleRow {
                self.tableView.scrollToRow(at: topVisibleRow, at: .top, animated: true)
            }
        })
    }
}

// MARK: - Table view data source
extension ListEventsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return data?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let event = data?[indexPath.row] else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveredEventCell", for: indexPath)
            as? ListEventsTableViewCell

        cell?.setDiscoveredEvent(event)

        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.displayEvent(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListEventsTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {

        return UIImage(named: "ListEventsTabBarIconFilled")
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {

        let title = "FOMO"

        return NSAttributedString(string: title)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {

        let description = "Loading events"

        return NSAttributedString(string: description)
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTap view: UIView) {
        fetchFromNetwork()
    }
}
