//
//  CarModelTableViewController.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents
import WHPromise

class CarModelTableViewController: PaginateTableViewController, PaginatedTableViewControllerDelegate {
    
    var viewModel: TableViewViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelTableViewCellNib = UINib(nibName: "CarModelTableViewCell", bundle: Bundle.main)
        tableView.register(modelTableViewCellNib, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        title = (viewModel as! CarModelViewModel).title()
        
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(CarManufacturerTableViewController.back))
        navigationItem.leftBarButtonItem = backButton
        
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
    
    @objc func back() {
        viewModel?.dismiss()
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

extension CarModelTableViewController {
    static func instanceWith(viewModel: CarModelViewModel) -> CarModelTableViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let modelViewController = storyboard.instantiateViewController(withIdentifier: "CarModelTableViewController") as? CarModelTableViewController else {
            return nil
        }
        modelViewController.viewModel = viewModel
        modelViewController.pagenatedViewDelegate = modelViewController
        return modelViewController
    }
}

extension CarModelTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel!.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CarModelTableViewCell, let viewModel = viewModel as? CarModelViewModel else {
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
            return defaultCell
        }
        cell.configBy(viewModel: viewModel, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelectRowAt(indexPath)
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
