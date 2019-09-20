//
//  TableViewService.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import MyService

public protocol TableViewServiceProtocol {
    func getData(completeHandler: NetworkCompletionHandler)
    func postData(parameters: [AnyHashable: Any], completeHandler: NetworkCompletionHandler)
}
