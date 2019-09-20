//
//  Page.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

struct Page {
    var current: Int
    var total: Int
    var next: Int {
        return current + 1
    }
    func hasNextPage() -> Bool {
        return next < total
    }
}
