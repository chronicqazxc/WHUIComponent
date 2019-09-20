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
}

@objcMembers
public class PaginateTableViewController: UITableViewController {
    
    public private(set) var viewModel: TableViewViewModel!
    
    fileprivate enum Constant {
        static let PaginateTableViewController = "PaginateTableViewController"
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(PaginateTableViewController.refresh), for: .valueChanged)
        
        viewModel = TableViewViewModel { [weak self] (state: TableViewState) in
            guard let strongSelf = self else {
                return
            }
            switch state.loadingType {
            case .more?:
                strongSelf.tableView.reloadData()
                print("more")
            case .refresh?:
                strongSelf.tableView.reloadData()
                print("reload")
            case .none:
                break
            }
            
            switch state.loadingStatus {
            case .idle:
                if strongSelf.tableView.refreshControl?.isRefreshing == true {
                    strongSelf.tableView.refreshControl?.endRefreshing()
                }
            case .loading:
                if state.loadingType == .refresh {
                    strongSelf.tableView.refreshControl?.beginRefreshing()
                }
            }
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100//viewModel.data.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    func refresh() {
        viewModel.refresh()
    }

}

extension PaginateTableViewController {
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.tableView.isTracking else {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        print("distanceFromBottom: \(distanceFromBottom)\nheight:\(height)")
        if distanceFromBottom < height {
            print(" you reached end of the table")
            viewModel.getMore()
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
