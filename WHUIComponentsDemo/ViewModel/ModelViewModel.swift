//
//  ModelViewModel.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/22.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents
import WHCoreServices
import WHPromise

class ModelViewModel: TableViewViewModelProtocol {
    weak public var coordinator: Coordinator?
    
    public private(set) var indexOfCurrentSelected: IndexPath?
    public private(set) var state = TableViewState()
    public private(set) var data: [TableViewDataModel] = []
    let manufacturer: Manufacturer
    
    public var callback: CallBack?
    public private(set) var page = Page.initialPage()
    
    public required init(_ callback: CallBack? = nil, manufacturer: Manufacturer) {
        self.callback = callback
        self.manufacturer = manufacturer
    }
    
    public func willCallBack(_ type: TableViewState.LoadingType, data: [TableViewDataModel]?) {
        state.loadingType = type
        guard let data = data else {
            return
        }
        switch type {
        case .more:
            self.data = self.data + data
        case .refresh:
            self.data = data
        }
    }
    
    public func didCallBack(_ type: TableViewState.LoadingType) {
        state.loadingType = nil
    }
    
    public func apiRequest(type: TableViewState.LoadingType, _ completeHandler: @escaping APIRequestComplete) {
        refreshPageIfNeeded(type)
        
        Service.shared.getModel(manufacturerId: manufacturer.id, page: page.next) { (data, response, error) in
            guard self.page.hasNextPage() == true else {
                completeHandler(nil, nil, APIError.EOF)
                return
            }
            completeHandler(data, response, error)
        }
    }
    
    public func apiRequest(type: TableViewState.LoadingType) -> Promise<Data> {
        let promise = Promise<Data>.init { (fulfill, reject) in
            self.refreshPageIfNeeded(type)
            
            Service.shared.getModel(manufacturerId: self.manufacturer.id, page: self.page.next) { (data, response, error) in
                guard self.page.hasNextPage() == true else {
                    reject(APIError.EOF)
                    return
                }
                if let error = error {
                    reject(error)
                } else if let data = data {
                    let model = self.parse(data)
                    self.willCallBack(type, data: model)
                    fulfill(data)
                } else {
                    reject(APIError.unknow)
                }
            }
        }
        return promise
    }
    
    public func refreshPageIfNeeded(_ type: TableViewState.LoadingType) {
        if type == .refresh {
            page = Page.initialPage()
        }
    }
    
    public func parse(_ data: Data) -> [TableViewDataModel]? {

        guard let serializedJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [[AnyHashable : Any]],
            let json = serializedJson.first else {
                return nil
        }
        guard let wkda = json["wkda"] as? [String: String],
            let currentPage = json["page"] as? Int,
            let totalPage = json["totalPageCount"] as? Int else {
                return nil
        }
        page = Page(current: currentPage, total: totalPage)
        return wkda.map {
            return Model(image: nil, id: $0.value, manufacturer: manufacturer)
        }
    }
    
    public func selectDataAt(indexPath: IndexPath) {
        indexOfCurrentSelected = indexPath
        coordinator?.navigateToNextPage()
    }
    
    public func selectedData() -> [TableViewDataModel] {
        if let indexOfCurrentSelected = indexOfCurrentSelected {
            return [data[indexOfCurrentSelected.row]]
        } else {
            return []
        }
    }
    
    func didDismiss() {
        coordinator?.naviageBackToPreviousPage()
    }
}
