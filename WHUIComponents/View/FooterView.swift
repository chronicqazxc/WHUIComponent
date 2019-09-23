//
//  FooterView.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/22.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit


/// WHFooterView, used in table view with only one sction or the last section.
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
        text = "✊That's all!"
    }
    
    public func putllToPage(_ page: Int?) {
        if let page = page {
            text = "👆Pull up to page \(page)"
        } else {
            text = "👆Keep pull up!"
        }
    }
}
