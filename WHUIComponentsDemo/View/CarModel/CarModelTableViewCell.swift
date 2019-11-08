//
//  CarModelTableViewCell.swift
//  WHUIComponentsDemo
//
//  Created by Wayne Hsiao on 2019/9/23.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents

class CarModelTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.font = UIFont.whTitle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configBy(viewModel: CarModelViewModel, indexPath: IndexPath) {
        if indexPath.row % 2 != 0 {
            backgroundColor = UIColor.lightGray
        } else {
            backgroundColor = UIColor.white
        }
        let model = viewModel.data[indexPath.row]
        
        textLabel?.text = model.content
    }
}
