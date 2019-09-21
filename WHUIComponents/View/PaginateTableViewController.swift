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
    open var dataDelegate: PaginateTableViewControllerDataDelegate!
    open var viewModel: TableViewViewModelProtocol!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(PaginateTableViewController.refresh), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func refresh() {
        if loadingStatus == .idle {
            loadingStart(.refresh)
            viewModel.refresh()
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
        return dataDelegate.tableView(tableView, numberOfRowInSection: section)
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataDelegate.tableView(tableView, cellForRowAt: indexPath)
    }
}

// MARK: - Delegate
extension PaginateTableViewController {
    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        func isScrollDown() -> Bool {
            return offset > 0
        }
        
//        func isHideNavigationBar() -> Bool {
//            return scrollView.contentOffset.y > offset
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            if scrollView.isDragging {
//                let hideNavigationBar = isHideNavigationBar()
//                if hideNavigationBar == false {
//                    print(hideNavigationBar)
//                }
//                self.navigationController?.setNavigationBarHidden(hideNavigationBar, animated: false)
//            }
//        }

        guard self.tableView.isTracking && isScrollDown() else {
            return
        }

        let height = scrollView.frame.size.height
        let distanceFromBottom = scrollView.contentSize.height - offset
        if distanceFromBottom < height && loadingStatus == .idle {
            loadingStart(.more)
            viewModel.getMore()
        }
    }
}

// MARK: - Delegate
extension PaginateTableViewController {
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataDelegate.tableView(tableView, DidSelectRowAt: indexPath)
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
