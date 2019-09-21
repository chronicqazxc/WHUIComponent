//
//  Page.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

public struct Page {
    public private(set) var current: Int
    public private(set) var total: Int
    public var next: Int {
        return current + 1
    }
    public func hasNextPage() -> Bool {
        return next < total
    }
    
    public init(current: Int, total: Int) {
        self.current = current
        self.total = total
    }
    
    public static func initialPage() -> Page {
        return Page(current: -1, total: 1)
    }
}
