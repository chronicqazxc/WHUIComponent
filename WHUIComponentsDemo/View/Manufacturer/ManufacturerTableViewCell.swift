//
//  ManufacturerTableViewCell.swift
//  WHUIComponentsDemo
//
//  Created by Wayne Hsiao on 2019/9/22.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit

class ManufacturerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textAlignment = .center
        textLabel?.font = UIFont.whTitle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
