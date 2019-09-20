//
//  ManufacturerTableViewController.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents

class ManufacturerTableViewController: PaginateTableViewController {
    
    lazy var viewModel: TableViewViewModelProtocol? = {
        func eofError() {
            let controller = UIAlertController(title: nil, message: "End of file", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        }
        
        return ManufacturerViewModel { [weak self] (state: TableViewState.LoadingType, models, error) in
            guard let strongSelf = self else {
                return
            }
            defer {
                strongSelf.loadingEnd()
            }
            switch state {
            case .more:
                DispatchQueue.main.async {
                    if let error = error as? APIError, error == APIError.EOF {
                        eofError()
                    } else {
                        strongSelf.tableView.reloadData()
                    }
                }
            case .refresh:
                DispatchQueue.main.async {
                    if let error = error as? APIError, error == APIError.EOF {
                        eofError()
                    } else {
                        strongSelf.tableView.reloadData()
                    }
                }
            }
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataDelegate = self
    }
}

extension ManufacturerTableViewController: PaginateTableViewControllerDataDelegate {
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = viewModel?.data[indexPath.row]
        cell.textLabel?.text = model?.content
        return cell
    }
    
    @objc
    func reload() {
        viewModel!.refresh()
    }
    
    func getMore() {
        viewModel!.getMore()
    }
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRowInSection(_ section: Int) -> Int {
        return viewModel!.data.count
    }
}
