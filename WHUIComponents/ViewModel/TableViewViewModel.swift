//
//  TableViewDataSource.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import MyService

public typealias CallBack = (_ loadingType: TableViewState.LoadingType, _ data: [TableViewDataModelProtocol]?, _ error: Error?) -> Void

/// TableView view model. Process busniess logic and API requests.
public protocol TableViewViewModelProtocol: class {
    
    /// TableView state.
    var state: TableViewState { get }
    
    /// Data to represent.
    var data: [TableViewDataModelProtocol] { get }
    
    /// Callback when request complete.
    var callback: CallBack? { get }
    
    /// Required initial method.
    ///
    /// - Parameter callback: Callback when request complete
    init(_ callback: @escaping CallBack)
    
    /// Will callback to view.
    ///
    /// - Parameter type: Loading type
    func willCallBack(_ type: TableViewState.LoadingType, data: [TableViewDataModelProtocol]?)
    
    /// Callback to view complete.
    ///
    /// - Parameter type: Loading type
    func didCallBack(_ type: TableViewState.LoadingType)
    
    /// Pull refresh
    func refresh()
    
    /// Trigger when scroll to bottonm
    func getMore()
    
    /// API call
    ///
    /// - Parameters:
    ///   - type: Loading type
    ///   - escapingcompleteHandler: API request complete handler
    func apiRequest(type: TableViewState.LoadingType, _ escapingcompleteHandler: @escaping NetworkCompletionHandler)
    
    
    /// Parse and return designated data model.
    ///
    /// - Returns: Data model which confirmed TableViewDataModelProtocol.
    func parse(_ data: Data) -> [TableViewDataModelProtocol]?
}

extension TableViewViewModelProtocol {
    public func refresh() {
        let type = TableViewState.LoadingType.refresh
        apiRequest(type: type) { (data, response, error) in
            guard let data = data else {
                self.callback?(type, nil, error)
                self.didCallBack(type)
                return
            }
            let model = self.parse(data)
            self.willCallBack(type, data: model)
            self.callback?(type, model, error)
            self.didCallBack(type)
        }
    }
    
    public func getMore() {
        let type = TableViewState.LoadingType.more
        apiRequest(type: type) { (data, response, error) in
            guard let data = data else {
                self.callback?(type, nil, error)
                self.didCallBack(type)
                return
            }
            
            let model = self.parse(data)
            self.willCallBack(type, data: model)
            self.callback?(type, model, error)
            self.didCallBack(type)
        }
    }
}
