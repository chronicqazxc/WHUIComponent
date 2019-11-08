//
//  ViewController.swift
//  WHUIComponentsDemo
//
//  Created by Wayne Hsiao on 2019/9/19.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents

class ViewControllerViewModel {
    var coordinator: Coordinator?
    
    func buttonTapped() {
        coordinator?.navigateToNextPage()
    }
}

class ViewController: UIViewController {
    
    var viewModel: ViewControllerViewModel?
    
    static func instanceFromStoryboard() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let entryViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        return entryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo"
    }

    @IBAction func showPaginateTableView(_ sender: Any) {
        viewModel?.buttonTapped()
    }
    
}

