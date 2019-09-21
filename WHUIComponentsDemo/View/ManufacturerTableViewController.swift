//
//  ManufacturerTableViewController.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents

class ManufacturerTableViewController: PaginateTableViewController, CoordinatorViewController {
    enum Constant {
        static let parameterKey = "SelectedManufacturer"
    }
    
    var coordinateDelegate: CoordinatorViewContollerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Manufacturer"
        viewModel = ManufacturerViewModel { [weak self] (state: TableViewState.LoadingType, models, error) in
            guard let strongSelf = self else {
                return
            }
            defer {
                strongSelf.loadingEnd()
            }
            switch state {
            case .more:
                DispatchQueue.main.async {
                    guard error == nil else {
                        return
                    }
                    strongSelf.tableView.reloadData()
                }
            case .refresh:
                DispatchQueue.main.async {
                    guard error == nil else {
                        return
                    }
                    strongSelf.tableView.reloadData()
                }
            }
        }
        dataDelegate = viewModel as? PaginateTableViewControllerDataDelegate
        viewModel.refresh()
    }
}

extension ManufacturerTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        coordinateDelegate?.navigateToNextPage()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 120)
        let footerView = FooterView(frame: rect)
        
        if viewModel.page.hasNextPage() == false {
            footerView.reachEndOfPage()
        } else {
            footerView.putllToPage(viewModel.page.next+1)
        }
        return footerView
    }
}
