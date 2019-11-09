//
//  IntroductionViewController.swift
//  WHUIComponentsDemo
//
//  Created by Wayne Hsiao on 2019/11/8.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {
    
    static func instanceFromStoryboard() -> IntroductionViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "IntroductionViewController") as! IntroductionViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
