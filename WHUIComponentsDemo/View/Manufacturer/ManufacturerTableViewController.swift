//
//  ManufacturerTableViewController.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents
import WHPromise

class ManufacturerTableViewController: PaginateTableViewController, CoordinatorViewController {
    enum Constant {
        static let parameterKey = "SelectedManufacturer"
    }
    
    var coordinateDelegate: CoordinatorViewContollerDelegate?
    
    override var dateUpdatedPromise: Promise<Data>? {
        didSet {
            dateUpdatedPromise?.then({ [weak self] (data) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {
                    strongSelf.loadingEnd()
                    strongSelf.tableView.reloadData()
                }
            }).catch({ [weak self] (error) in
                guard let strongSelf = self else {
                    return
                }
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                DispatchQueue.main.async {
                    strongSelf.loadingEnd()
                    strongSelf.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manufacturer"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        
        dateUpdatedPromise = viewModel?.promiseByRefresh()

        let manufacturerTableViewCellNib = UINib(nibName: "ManufacturerTableViewCell", bundle: Bundle.main)
        tableView.register(manufacturerTableViewCellNib, forCellReuseIdentifier: "cell")
    }
}

extension ManufacturerTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.data.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ManufacturerTableViewCell, let viewModel = viewModel as? ManufacturerViewModel {
            cell.configBy(viewModel: viewModel, indexPath: indexPath)
            return cell
        }
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        return defaultCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        coordinateDelegate?.navigateToNextPage()
        tableView.deselectRow(at: indexPath, animated: true)
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
