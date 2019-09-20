//
//  PaginateTableViewController.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit

public enum PaginateTableViewControllerError: Error {
    case typeError
    case viewModelNil
}

public protocol PaginateTableViewControllerDataDelegate: class {
    func numberOfSection() -> Int
    func numberOfRowInSection(_ section: Int) -> Int
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
    func reload()
    func getMore()
}

enum LoadingStatus {
    case idle
    case loading
}


/// PaginateTableViewController adopt MVVM pattern, how to customize your paginated view controller.
/// 1. Inherited PaginateTableViewController as well as adopt protocol PaginateTableViewControllerDataDelegate.
/// 2. Implement TableViewViewModel.
/// 3. Your data model must adopt TableViewDataModel.
@objcMembers
open class PaginateTableViewController: UITableViewController {
    
    var loadingStatus = LoadingStatus.idle

    weak public var dataDelegate: PaginateTableViewControllerDataDelegate!
    
    fileprivate enum Constant {
        static let PaginateTableViewController = "PaginateTableViewController"
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(PaginateTableViewController.refresh), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return dataDelegate.numberOfSection()
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDelegate.numberOfRowInSection(section)
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataDelegate.cellForRowAt(indexPath: indexPath)
    }
    
    func refresh() {
        if loadingStatus == .idle {
            loadingStart(.refresh)
            dataDelegate.reload()
        }
    }
    
    /// Show loading indicator and change the internal status.
    public func loadingStart(_ type: TableViewState.LoadingType) {
        loadingStatus = .loading
        if type == .refresh {
            tableView.refreshControl?.beginRefreshing()
        }
    }
    
    /// Dismiss loading indicator and change the internal status.
    public func loadingEnd() {
        loadingStatus = .idle
        DispatchQueue.main.async {
            if self.tableView.refreshControl?.isRefreshing == true {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }

}

extension PaginateTableViewController {
    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.tableView.isTracking && scrollView.contentOffset.y > 0 else {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && loadingStatus == .idle {
            loadingStart(.more)
            dataDelegate.getMore()
        }
    }
}

extension PaginateTableViewController {
    public static func controller() throws -> PaginateTableViewController {
        guard let controller = Resource.storyBoard.instantiateViewController(withIdentifier: Constant.PaginateTableViewController) as? PaginateTableViewController else {
            throw PaginateTableViewControllerError.typeError
        }
        return controller
    }
}
