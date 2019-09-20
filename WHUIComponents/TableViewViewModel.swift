//
//  TableViewDataSource.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

public typealias CallBack = (TableViewState.LoadType) -> Void

public protocol TableViewViewModelProtocol {
    var state: TableViewState { get }
    var data: [TableViewDataModelProtocol] { get }
    var callback: CallBack? { get }
    init(_ callback: @escaping CallBack)
    func willCallBack(_ type: TableViewState.LoadType)
    func didCallBack(_ type: TableViewState.LoadType)
    func refresh()
    func getMore()
}

extension TableViewViewModelProtocol {
    public func refresh() {
        willCallBack(.refresh)
        callback?(.refresh)
        didCallBack(.refresh)
    }
    
    public func getMore() {
        willCallBack(.more)
        callback?(.more)
        didCallBack(.more)
    }
}

public class TableViewViewModel: TableViewViewModelProtocol {
    public private(set) var state = TableViewState()
    public private(set) var data: [TableViewDataModelProtocol]
    public private(set) var callback: CallBack?
    
    required public init(_ callback: @escaping CallBack) {
        self.callback = callback
        self.data = [TableViewDataModelProtocol]()
    }
    
    public func willCallBack(_ type: TableViewState.LoadType) {
        print("will callback")
    }
    
    public func didCallBack(_ type: TableViewState.LoadType) {
        print("did callback")
    }
}

