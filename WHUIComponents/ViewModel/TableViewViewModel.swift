//
//  TableViewDataSource.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

public typealias CallBack = (TableViewState) -> Void

public protocol TableViewViewModelProtocol {
    var state: TableViewState { get }
    var data: [TableViewDataModelProtocol] { get }
    var callback: CallBack? { get }
    init(_ callback: @escaping CallBack)
    func willCallBack(_ type: TableViewState.LoadingType)
    func didCallBack(_ type: TableViewState.LoadingType)
    func refresh()
    func getMore()
}

extension TableViewViewModelProtocol {
    public func refresh() {
        guard state.loadingStatus == .idle else {
            return
        }
        willCallBack(.refresh)
        // TODO: API request
        callback?(self.state)
        didCallBack(.refresh)
    }
    
    public func getMore() {
        guard state.loadingStatus == .idle else {
            return
        }
        willCallBack(.more)
        // TODO: API request
        callback?(self.state)
        didCallBack(.more)
    }
}

public class TableViewViewModel: TableViewViewModelProtocol {
    public private(set) var state = TableViewState(loadingType: nil, loadingStatus: .idle)
    public private(set) var data: [TableViewDataModelProtocol]
    public private(set) var callback: CallBack?
    
    required public init(_ callback: @escaping CallBack) {
        self.callback = callback
        self.data = [TableViewDataModelProtocol]()
    }
    
    public func willCallBack(_ type: TableViewState.LoadingType) {
        state.loadingStatus = .loading
        state.loadingType = type
        callback?(state)
    }
    
    public func didCallBack(_ type: TableViewState.LoadingType) {
        state.loadingStatus = .idle
        state.loadingType = nil
        callback?(state)
    }
}

