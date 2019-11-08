//
//  TableViewDataSource.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHCoreServices
import WHPromise

public typealias APIRequestComplete = (Data?, URLResponse?, Error?) -> Void


/// Will be invoked when API request complete by TableViewModel.
public typealias CallBack = (
    _ loadingType: TableViewState.LoadingType,
    _ data: [TableViewDataModel]?,
    _ error: Error?) -> Void

/// TableView view model. Process busniess logic and API requests.
public protocol TableViewViewModelProtocol: class {
    
    /// TableView state.
    var state: TableViewState { get }
    
    /// Data to represent.
    var data: [TableViewDataModel] { get }
    
    /// Callback when request complete.
    var callback: CallBack? { get set }
    
    /// Presresent the page information.
    var page: Page { get }
    
    /// Should be weak
    var coordinator: Coordinator? { get set }
    
    /// Will callback to view.
    ///
    /// - Parameter type: Loading type
    func willCallBack(_ type: TableViewState.LoadingType, data: [TableViewDataModel]?)
    
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
    func apiRequest(type: TableViewState.LoadingType, _ escapingcompleteHandler: @escaping APIRequestComplete)
    
    func apiRequest(type: TableViewState.LoadingType) -> Promise<Data>
    
    /// Parse and return designated data model.
    ///
    /// - Returns: Data model which confirmed TableViewDataModel.
    func parse(_ data: Data) -> [TableViewDataModel]?
    
    /// Call when tableView did selected.
    /// - Parameter indexPath: IndexPath of selected.
    func selectDataAt(indexPath: IndexPath)
    
    /// Return selected data.
    func selectedData() -> [TableViewDataModel]
}

extension TableViewViewModelProtocol {
    
    public func promiseByRefresh() -> Promise<Data> {
        let type = TableViewState.LoadingType.refresh
        return apiRequest(type: type)
    }
    
    /// Pull to refresh.
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
    
    public func promiseByGetMore() -> Promise<Data> {
        let type = TableViewState.LoadingType.more
        return apiRequest(type: type)
    }
    
    /// Scroll down to get more.
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
