//
//  MockTableViewDataModel.swift
//  WHUIComponentsTests
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
@testable import WHUIComponents

struct MockTableViewDataModel: TableViewDataModel {
    var title: String
    var content: String
    var image: UIImage?
}
