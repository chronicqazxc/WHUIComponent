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
    
    weak var coordinateDelegate: CoordinatorViewContollerDelegate?
    
    var modelViewModel: ModelViewModel {
        return viewModel as! ModelViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(modelViewModel.manufacturer!.content)"
        viewModel.refresh()
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
        return viewModel.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = viewModel.data[indexPath.row]
        cell.textLabel?.text = model.title
        return cell
    }
    
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
