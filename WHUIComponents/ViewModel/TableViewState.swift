//
//  TableViewState.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation


/// Represent tableView loading types.
public struct TableViewState {
    public enum LoadingType {
        case refresh
        case more
    }
    
    public var loadingType: LoadingType?
    
    public init(loadingType: LoadingType?) {
        self.loadingType = loadingType
    }
}
