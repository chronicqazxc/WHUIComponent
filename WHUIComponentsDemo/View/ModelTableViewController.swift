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
    
    fileprivate var model: Model!
    
    weak var coordinateDelegate: CoordinatorViewContollerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(model.manufacturer.content)"
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

extension ModelTableViewController {
    static func initFromManufacturer(_ manufacturer: Manufacturer) -> ModelTableViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let modelViewController = storyboard.instantiateViewController(withIdentifier: "ModelTableViewController") as? ModelTableViewController else {
            return nil
        }
        modelViewController.model = Model(manufacturer: manufacturer)
        return modelViewController
    }
}
