//
//  ResourceBundle.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

enum Resource {
    fileprivate enum Constant {
        static let WHUIComponents = "com.wayne.hsiao.WHUIComponents"
        static let storyboard = "Storyboard"
    }
    
    /// WHUIComponent bundle.
    public static let bundle = Bundle(identifier: Constant.WHUIComponents)
    
    /// Storyboard of WHUIComponent.
    public static let storyBoard = UIStoryboard(name: Constant.storyboard, bundle: bundle)
}
