//
//  PaginateTableViewController.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHPromise

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

/// PaginateTableViewController which implemented paginate in UITableView, this is the base class only control the pull refresh and scroll to bottom to load more logic, the reset of all logics have been delegated to TableViewViewModel which should be implemented by the users. The the PaginateTableViewController adopted MVVM, following steps introduce the steps to customized your paginated UITableView.
/// 1. Implement TableViewViewModel.
/// 2. Confrim your data model to protocol TableViewDataModel.
@objcMembers
open class PaginateTableViewController: UITableViewController {
    
    fileprivate enum Constant {
        static let PaginateTableViewController = "PaginateTableViewController"
    }
    
    var loadingStatus = LoadingStatus.idle
    open var dateUpdatedPromise: Promise<Data>?
    
    /// Responsible in dataSource and delegate in tableView, should not be nil.
    open var viewModel: TableViewViewModelProtocol?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(PaginateTableViewController.refresh), for: .valueChanged)
    }
    
    func refresh() {
        if loadingStatus == .idle {
            loadingStart(.refresh)
            dateUpdatedPromise = viewModel?.promiseByRefresh()
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
        return 0
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectDataAt(indexPath: indexPath)
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
            dateUpdatedPromise = viewModel?.promiseByGetMore()
        }
    }
}

// MARK: - Initializer
extension PaginateTableViewController {
    
    /// Convenience method to generate PaginateTableViewController
    ///
    /// - Parameter viewModel: Inject pattern, pass your custom view model on your demand.
    /// - Returns: The PaginateTableViewController.
    /// - Throws: Throws PaginateTableViewControllerError.
    public static func controller(withViewModel viewModel: TableViewViewModelProtocol? = nil) throws -> PaginateTableViewController {
        guard let controller = Resource.storyBoard.instantiateViewController(withIdentifier: Constant.PaginateTableViewController) as? PaginateTableViewController else {
            throw PaginateTableViewControllerError.typeError
        }
        controller.viewModel = viewModel
        return controller
    }
}
