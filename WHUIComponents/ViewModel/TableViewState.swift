//
//  TableViewState.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

public struct TableViewState {
    public enum LoadingType {
        case refresh
        case more
    }
    public enum LoadingStatus {
        case idle
        case loading
    }
    
    public var loadingType: LoadingType?
    public var loadingStatus: LoadingStatus
}
