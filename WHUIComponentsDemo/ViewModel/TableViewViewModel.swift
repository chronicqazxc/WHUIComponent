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
import WHUIComponents

public typealias APIRequestComplete = (Data?, URLResponse?, Error?) -> Void

public typealias SuccessCallback = (_ loadingType: TableViewState.LoadingType) -> Void
public typealias FailureCallback = (_ loadingType: TableViewState.LoadingType, _ error: Error) -> Void

/// TableView view model. Process busniess logic and API requests.
public protocol TableViewViewModelProtocol: class {
    
    /// TableView state.
    var state: TableViewState { get }
    
    /// Data to represent.
    var data: [TableViewDataModel] { get }
    
    var successCallback: SuccessCallback? { get set }
    var failureCallback: FailureCallback? { get set }
    
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
    
    /// API call
    ///
    /// - Parameters:
    ///   - type: Loading type
    ///   - escapingcompleteHandler: API request complete handler
    func apiRequest(type: TableViewState.LoadingType, _ escapingcompleteHandler: @escaping APIRequestComplete)
    
    /// Parse and return designated data model.
    ///
    /// - Returns: Data model which confirmed TableViewDataModel.
    func parse(_ data: Data) -> [TableViewDataModel]?
    
    /// Return selected data.
    func selectedData() -> [TableViewDataModel]
    
    /// Data source of number of sections.
    func numberOfSections() -> Int
    
    /// Data source of number of rows in section.
    /// - Parameter section: Section of tableView.
    func numberOfRowsInSection(_ section: Int) -> Int
    
    /// Invoke when table view did select.
    /// - Parameter indexPath: IndexPath
    func didSelectRowAt(_ indexPath: IndexPath)
    
    /// Data model promise.
    var promise: Promise<[TableViewDataModel]> { get set }
    
    /// Invoke when view controller going to dismiss.
    func dismiss()
}

extension TableViewViewModelProtocol {
    /// Pull to refresh.
    public func refreshRequest() {
        promise = refreshRequestPromise()
        let type = TableViewState.LoadingType.refresh
        setupPromise(promise, type: type)
    }
    
    /// Promise from refresh operation.
    public func refreshRequestPromise() -> Promise<[TableViewDataModel]> {
        let type = TableViewState.LoadingType.refresh
        return apiRequestPromise(type: type)
    }
    
    /// Scroll to bottom to get more.
    public func getMoreRequest() {
        promise = getMoreRequestPromise()
        let type = TableViewState.LoadingType.more
        setupPromise(promise, type: type)
    }
    
    /// Promise from getMore operation.
    public func getMoreRequestPromise() -> Promise<[TableViewDataModel]> {
        let type = TableViewState.LoadingType.more
        return apiRequestPromise(type: type)
    }
    
    func setupPromise(_ promise: Promise<[TableViewDataModel]>, type: TableViewState.LoadingType) {
        promise.then { [weak self] (datas) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.successCallback?(type)
        }.catch { [weak self] (error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.failureCallback?(type, error)
        }
    }
    
    public func apiRequestPromise(type: TableViewState.LoadingType) -> Promise<[TableViewDataModel]> {
        let promise = Promise<[TableViewDataModel]>.init { (fulfill, reject) in
            self.apiRequest(type: type) { (data, response, error) in
                guard let data = data,
                    let model = self.parse(data) else {
                        reject(error!)
                        self.didCallBack(type)
                        return
                }
                self.willCallBack(type, data: model)
                fulfill(model)
                self.didCallBack(type)
            }
        }
        return promise
    }
}

@objc protocol NavigationBarDismissible: NSObjectProtocol {
    @objc func barItemAction()
}

@objc protocol NavigationBarButtonItemHandler: NSObjectProtocol {
    func leftBarButtonItemName() -> String
    func rightBarButtonItemName() -> String
    @objc func leftBarButtonItemAction()
    @objc func rightBarButtonItemAction()
}
