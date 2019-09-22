//
//  TableViewDataModel.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

public protocol TableViewDataModel {
    var title: String { get }
    var content: String { get }
    var image: UIImage? { get }
}
