//
//  ManufacturerViewModel.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents
import MyService

public enum APIError: Error {
    case invalidURL
    case EOF
}

public class ManufacturerViewModel: TableViewViewModelProtocol {
    
    public private(set) var state = TableViewState(loadingType: nil)
    public private(set) var data: [TableViewDataModelProtocol]
    public private(set) var callback: CallBack?
    fileprivate var page = Page(current: -1, total: 100)
    
    required public init(_ callback: @escaping CallBack) {
        self.callback = callback
        self.data = [Manufacture]()
    }
    
    public func willCallBack(_ type: TableViewState.LoadingType, data :[TableViewDataModelProtocol]?) {
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
    
    public func apiRequest(type: TableViewState.LoadingType, _ completeHandler: @escaping NetworkCompletionHandler) {
        refreshPageIfNeeded(type)
        print("next page: \(page.next)")
        guard let url = URL(string: "http://api-aws-eu-qa-1.auto1-test.com/v1/car-types/manufacturer?page=\(page.next)&pageSize=10&wa_key=coding-puzzle-client-449cc9d") else {
            completeHandler(nil, nil, APIError.invalidURL)
            return
        }
        
        guard page.hasNextPage() == true else {
            completeHandler(nil, nil, APIError.EOF)
            return
        }
        
        Service.shared.get(url: url) { (data, response, error) in
            completeHandler(data, response, error)
        }
    }
    
    func refreshPageIfNeeded(_ type: TableViewState.LoadingType) {
        if type == .refresh {
            page = Page(current: -1, total: 100)
        }
    }
    
    public func parse(_ data: Data) -> [TableViewDataModelProtocol]? {
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        guard let wkda = json?["wkda"] as? [String: String],
            let currentPage = json?["page"] as? Int,
            let totalPage = json?["totalPageCount"] as? Int else {
                return nil
        }
        page.current = currentPage
        page.total = totalPage
        return wkda.map {
            return Manufacture(id: $0.key, model: $0.value)
        }
    }
}
