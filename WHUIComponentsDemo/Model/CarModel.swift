//
//  CarModel.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

struct CarModel: TableViewDataModel {
    
    var title: String {
        return manufacturer.title
    }
    
    var content: String {
        return id
    }
    
    var image: UIImage?
    
    let id: String
    let manufacturer: CarManufacturer
}
