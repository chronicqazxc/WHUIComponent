//
//  Font+.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/9/23.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    enum Constant {
        static let avenir = "Avenir"
        enum Size {
            static let content = CGFloat(17)
            static let title = CGFloat(24)
        }
    }
    
    
    /// WHStyle Font
    ///
    /// - Returns: Font for contents.
    static func whContent() -> UIFont {
        return UIFont(name: Constant.avenir,
                      size: Constant.Size.content) ?? UIFont.preferredFont(forTextStyle: .body)
    }
    
    /// WHStyle Font
    ///
    /// - Returns: Font for titles.
    static func whTitle() -> UIFont {
        return UIFont(name: Constant.avenir,
                      size: Constant.Size.title) ?? UIFont.preferredFont(forTextStyle: .title1)
    }
}
