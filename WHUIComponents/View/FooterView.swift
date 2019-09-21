//
//  FooterView.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/22.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit

public class FooterView: UILabel {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        textAlignment = .center
        textColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reachEndOfPage() {
        text = "✊It's the end."
    }
    
    public func notReachEndOfPage() {
        text = "👆Keep pull!"
    }
}
