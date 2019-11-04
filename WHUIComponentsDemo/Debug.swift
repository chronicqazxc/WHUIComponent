//
//  Debug.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/11/2.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents
import LifetimeTracker

protocol Debug: LifetimeTrackable {
    static var debugName: String { get }
    
    static var lifetimeConfiguration: LifetimeConfiguration { get }
    
    init()
}

class CoordinatorDebug: Debug {
    static var debugName: String {
        return "coordinator"
    }
    
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: self.debugName)
    }
    
    required init() {
        trackLifetime()
    }
}

class PaginateTableViewControllerDebug: PaginateTableViewController, Debug {
    static var debugName: String {
        return "view controller"
    }
    
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: self.debugName)
    }
    
    required init() {
        fatalError("Not implemented.")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        trackLifetime()
    }
}
