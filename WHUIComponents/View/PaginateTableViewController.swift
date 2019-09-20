//
//  PaginateTableViewController.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit

/// Error generated in PaginateTableViewController.
///
/// - typeError: The type is not the designated type.
public enum PaginateTableViewControllerError: Error {
    case typeError
}

/// The dataSource and delegate of PaginateTableViewController return following items.
/// 1. Number of sections.
/// 2. number of rows.
/// 3. Cell for row in section.
/// 4. User trigger pull refresh.
/// 5. User trigger load more.
public protocol PaginateTableViewControllerDataDelegate: class {
    
    /// Equal to the number of section dataSource method in UITableView.
    ///
    /// - Returns: Number of section.
    func numberOfSection() -> Int
    
    /// Equal to the number of row in sections dataSource method in UITableView.
    ///
    /// - Parameter section: UITableView section
    /// - Returns: Number of row in section.
    func numberOfRowInSection(_ section: Int) -> Int
    
    /// Equal to the number of cell for row at indexPath dataSource method in UITableView.
    ///
    /// - Parameter indexPath: UITableView indexPath
    /// - Returns: Designated cell.
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
    
    /// Pull to reload.
    func reload()
    
    /// Scroll to bottom to load more.
    func getMore()
}

/// Control the pull refresh and load more logic.
///
/// - idle: No loading.
/// - loading: Loading.
enum LoadingStatus {
    case idle
    case loading
}

/// PaginateTableViewController which implemented paginate in UITableView, this is the base class only control the pull refresh and scroll to bottom to load more logic, the reset of all have been delegated to dataDelegate which should be implemented by users. The the PaginateTableViewController adopted pattern MVVM, following steps show how to customized your paginated UITableView.
/// 1. Inherited PaginateTableViewController as well as adopt protocol PaginateTableViewControllerDataDelegate.
/// 2. Implement TableViewViewModel.
/// 3. Your data model must adopt TableViewDataModel.
@objcMembers
open class PaginateTableViewController: UITableViewController {
    
    fileprivate enum Constant {
        static let PaginateTableViewController = "PaginateTableViewController"
    }
    
    var loadingStatus = LoadingStatus.idle
    
    /// Responsible in dataSource and delegate in tableView, should not be nil.
    weak public var dataDelegate: PaginateTableViewControllerDataDelegate!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(PaginateTableViewController.refresh), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

// MARK: - DataSource
extension PaginateTableViewController {
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return dataDelegate.numberOfSection()
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDelegate.numberOfRowInSection(section)
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataDelegate.cellForRowAt(indexPath: indexPath)
    }
}

// MARK: - Delegate
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

// MARK: - Initializer
extension PaginateTableViewController {
    public static func controller() throws -> PaginateTableViewController {
        guard let controller = Resource.storyBoard.instantiateViewController(withIdentifier: Constant.PaginateTableViewController) as? PaginateTableViewController else {
            throw PaginateTableViewControllerError.typeError
        }
        return controller
    }
}
