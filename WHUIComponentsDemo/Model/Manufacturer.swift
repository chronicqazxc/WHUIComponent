//
//  Manufacture.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

public struct Manufacturer: TableViewDataModel {
    public var title: String {
        return model
    }
    
    public var content: String {
        return id
    }
    
    public var image: UIImage?
    
    let id: String
    let model: String
    
    init(id: String, model: String) {
        self.id = id
        self.model = model
    }
}
