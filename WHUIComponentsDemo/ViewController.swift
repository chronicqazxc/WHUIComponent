//
//  ViewController.swift
//  WHUIComponentsDemo
//
//  Created by Wayne Hsiao on 2019/9/19.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showPaginateTableView(_ sender: Any) {
        do {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ManufacturerTableViewController")
            let paginateViewController = viewController//ManufacturerTableViewController(style: .grouped)
            present(paginateViewController, animated: true, completion: nil)
        } catch {
            
        }
    }
    
}

