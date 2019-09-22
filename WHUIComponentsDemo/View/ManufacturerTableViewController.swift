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
    var manufacturerViewModel: ManufacturerViewModel {
        return viewModel as! ManufacturerViewModel
    }

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
        viewModel.refresh()
        let manufacturerTableViewCellNib = UINib(nibName: "ManufacturerTableViewCell", bundle: Bundle.main)
        tableView.register(manufacturerTableViewCellNib, forCellReuseIdentifier: "cell")
    }
}

extension ManufacturerTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = manufacturerViewModel.cell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        coordinateDelegate?.navigateToNextPage()
        tableView.deselectRow(at: indexPath, animated: true)
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
