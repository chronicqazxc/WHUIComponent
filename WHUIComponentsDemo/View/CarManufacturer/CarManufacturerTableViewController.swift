//
//  CarManufacturerTableViewController.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents
import WHPromise

class CarManufacturerTableViewController: PaginateTableViewController, PaginatedTableViewControllerDelegate {
    enum Constant {
        static let parameterKey = "SelectedManufacturer"
    }
    
    var viewModel: TableViewViewModelProtocol?
    
    static func instanceFromStoryboard() -> CarManufacturerTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let manufacturerViewController = storyboard.instantiateViewController(withIdentifier: "CarManufacturerTableViewController") as! CarManufacturerTableViewController
        manufacturerViewController.pagenatedViewDelegate = manufacturerViewController
        return manufacturerViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manufacturer"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")

        let manufacturerTableViewCellNib = ManufacturerTableViewCell.nib()
        tableView.register(manufacturerTableViewCellNib, forCellReuseIdentifier: "cell")
        
        navigationItem.hidesBackButton = true
        
        if let carManufacturerViewModel = viewModel as? CarManufacturerViewModel {
            let button = UIBarButtonItem(title: carManufacturerViewModel.barButtonItemName(),
                                         style: .plain, target: carManufacturerViewModel,
                                         action: #selector(carManufacturerViewModel.barItemAction))
            navigationItem.leftBarButtonItem = button
        }
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        viewModel?.successCallback = { [weak self] (type) in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.loadingEnd()
                strongSelf.tableView.reloadData()
            }
        }
        viewModel?.failureCallback = { (type, error) in
            print(error.localizedDescription)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func refresh() {
        viewModel?.refreshRequest()
    }
    
    func getMore() {
        viewModel?.getMoreRequest()
    }
}

extension CarManufacturerTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel!.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ManufacturerTableViewCell, let viewModel = viewModel as? CarManufacturerViewModel {
            cell.configBy(viewModel: viewModel, indexPath: indexPath)
            return cell
        }
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        return defaultCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel!.didSelectRowAt(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 120)
        let footerView = FooterView(frame: rect)
        
        if viewModel?.page.hasNextPage() == false {
            footerView.reachEndOfPage()
        } else {
            guard let viewModel = viewModel else {
                return nil
            }
            footerView.putllToPage(viewModel.page.next+1)
        }
        return footerView
    }
}
