//
//  Service.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import MyService

enum Constant {
    static let getManufacturers = "getManufacturers"
    static let getModel = "getModel"
    static let page = "page"
    static let pageSizeKey = "pageSize"
    static let manufacturer = "manufacturer"
    static let pageSize = "5"
}

extension Service {
    
    func getManufacturer(page: Int, _ completeHandler: @escaping NetworkCompletionHandler) {
        
        guard let path = Service.getPath(Constant.getManufacturers,
                                         token: [
                                            Constant.page: "\(page)",
                                            Constant.pageSizeKey: Constant.pageSize
            ]),
            let url = URL(string: path) else {
                completeHandler(nil, nil, APIError.invalidURL)
                return
        }
        
        Service.shared.get(url: url) { (data, response, error) in
            completeHandler(data, response, error)
        }
    }

    func getModel(manufacturerId: String, page: Int, _ completeHandler: @escaping NetworkCompletionHandler) {
        guard let path = Service.getPath(Constant.getModel,
                                         token: [
                                            Constant.manufacturer: manufacturerId,
                                            Constant.page: "\(page)"
            ]),
            let url = URL(string: path) else {
                completeHandler(nil, nil, APIError.invalidURL)
                return
        }
        
        Service.shared.get(url: url) { (data, response, error) in
            completeHandler(data, response, error)
        }
    }
}
