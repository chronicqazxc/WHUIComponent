//
//  Page.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

/// Represent page status.
public struct Page {
    
    /// Current page number.
    public private(set) var current: Int
    
    /// Count of total pages.
    public private(set) var total: Int
    
    /// Next page number.
    public var next: Int {
        return current + 1
    }
    
    /// If there is next page.
    ///
    /// - Returns: True if there is next page.
    public func hasNextPage() -> Bool {
        return next < total
    }
    
    
    /// Initial method.
    ///
    /// - Parameters:
    ///   - current: Number of current page.
    ///   - total: Count of total pages.
    public init(current: Int, total: Int) {
        self.current = current
        self.total = total
    }
    
    /// Convenience method to generate inital Page object.
    public static func initialPage() -> Page {
        return Page(current: -1, total: 1)
    }
}
