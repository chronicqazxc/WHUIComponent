//
//  TableViewDataSource.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

public typealias CallBack = (TableViewState.DataSource) -> Void

public class TableViewModel {
    public private(set) var state = TableViewState()
    private(set) var callback: CallBack?
    public init(_ callback: @escaping CallBack) {
        self.callback = callback
    }
    
    public func getData() {
        callback?(.reload)
    }
}

