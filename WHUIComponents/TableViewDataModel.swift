//
//  TableViewDataModel.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

public protocol TableViewDataModelProtocol {
    var title: String { get }
    var content: String { get }
    var image: UIImage { get }
}

public struct TableViewDataModel: TableViewDataModelProtocol {
    public var title: String
    public var content: String
    public var image: UIImage
}
