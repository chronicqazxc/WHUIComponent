//
//  ModelTableViewController.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents

class ModelTableViewController: PaginateTableViewController, CoordinatorViewController {
    
    var coordinateDelegate: CoordinatorViewContollerDelegate?
    
    var modelViewModel: ModelViewModel {
        return viewModel as! ModelViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelTableViewCellNib = UINib(nibName: "ModelTableViewCell", bundle: Bundle.main)
        tableView.register(modelTableViewCellNib, forCellReuseIdentifier: "cell")
        title = "\(modelViewModel.manufacturer!.title)"
        viewModel?.refresh()
        
    }
}

extension ModelTableViewController {
    static func initFromManufacturer(_ manufacturer: Manufacturer) -> ModelTableViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let modelViewController = storyboard.instantiateViewController(withIdentifier: "ModelTableViewController") as? ModelTableViewController else {
            return nil
        }
        modelViewController.viewModel = ModelViewModel { [weak modelViewController] (state: TableViewState.LoadingType, models, error) in
            guard let strongModelViewController = modelViewController else {
                return
            }
            defer {
                strongModelViewController.loadingEnd()
            }
            switch state {
            case .more:
                DispatchQueue.main.async {
                    guard error == nil else {
                        return
                    }
                    strongModelViewController.tableView.reloadData()
                }
            case .refresh:
                DispatchQueue.main.async {
                    guard error == nil else {
                        return
                    }
                    strongModelViewController.tableView.reloadData()
                }
            }
        }
        if let modelViewModel = modelViewController.viewModel as? ModelViewModel {
            modelViewModel.manufacturer = manufacturer
        }
        return modelViewController
    }
}

extension ModelTableViewController {
    
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = modelViewModel.cell(cell, forRowAtIndexPath: indexPath)
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
