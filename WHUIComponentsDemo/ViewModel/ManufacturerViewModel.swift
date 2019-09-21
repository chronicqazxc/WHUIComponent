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
    
    public var indexOfCurrentSelected: IndexPath?
    public private(set) var state = TableViewState()
    public private(set) var data: [TableViewDataModel]
    public private(set) var callback: CallBack?
    public private(set) var page = Page.initialPage()
    
    
    required public init(_ callback: @escaping CallBack) {
        self.callback = callback
        self.data = [Manufacturer]()
    }
    
    public func willCallBack(_ type: TableViewState.LoadingType, data :[TableViewDataModel]?) {
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
    
    public func apiRequest(type: TableViewState.LoadingType,
                           _ completeHandler: @escaping APIRequestComplete) {
        refreshPageIfNeeded(type)
        print("next page: \(page.next)")
        Service.shared.getManufacturer(page: page.next) { (data, response, error) in
            guard self.page.hasNextPage() == true else {
                completeHandler(nil, nil, APIError.EOF)
                return
            }
            completeHandler(data, response, error)
        }
    }
    
    public func refreshPageIfNeeded(_ type: TableViewState.LoadingType) {
        if type == .refresh {
            page = Page.initialPage()
        }
    }
    
    public func parse(_ data: Data) -> [TableViewDataModel]? {
        guard let serializedJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                return nil
        }
        guard let wkda = serializedJson["wkda"] as? [String: String],
            let currentPage = serializedJson["page"] as? Int,
            let totalPage = serializedJson["totalPageCount"] as? Int else {
                return nil
        }
        page = Page(current: currentPage, total: totalPage)
        return wkda.map {
            return Manufacturer(id: $0.key, model: $0.value)
        }
    }
}

extension ManufacturerViewModel: PaginateTableViewControllerDataDelegate {
    
    public func numberOfSection() -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = data[indexPath.row]
        cell.textLabel?.text = model.content
        return cell
    }
    
    public func tableView(_ tableView: UITableView, DidSelectRowAt indexPath: IndexPath) {
        indexOfCurrentSelected = indexPath
    }
}
