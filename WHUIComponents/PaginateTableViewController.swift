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

public class PaginateTableViewController: UITableViewController {
    
    public private(set) var viewModel: TableViewViewModel!
    
    fileprivate enum Constant {
        static let PaginateTableViewController = "PaginateTableViewController"
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TableViewViewModel { [weak self] (state: TableViewState.LoadType) in
            guard let strongSelf = self else {
                return
            }
            switch state {
            case .more:
                strongSelf.tableView.reloadData()
                print("more")
            case .refresh:
                strongSelf.tableView.reloadData()
                print("reload")
            }
        }
        
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
        return viewModel.data.count
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
