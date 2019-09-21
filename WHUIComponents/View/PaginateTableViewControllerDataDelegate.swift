//
//  PaginateTableViewControllerDataDelegate.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

/// The dataSource and delegate of PaginateTableViewController return following items.
/// 1. Number of sections.
/// 2. number of rows.
/// 3. Cell for row in section.
/// 4. User trigger pull refresh.
/// 5. User trigger load more.
public protocol PaginateTableViewControllerDataDelegate: class {
    
    /// Equal to the number of section dataSource method in UITableView.
    ///
    /// - Returns: Number of section.
    func numberOfSection() -> Int
    
    /// Equal to the number of row in sections dataSource method in UITableView.
    ///
    /// - Parameter section: UITableView section
    /// - Returns: Number of row in section.
    func numberOfRowInSection(_ section: Int) -> Int
    
    /// Equal to the number of cell for row at indexPath dataSource method in UITableView.
    ///
    /// - Parameter indexPath: UITableView indexPath
    /// - Returns: Designated cell.
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
    
    /// Pull to reload.
    func reload()
    
    /// Scroll to bottom to load more.
    func getMore()
    
    /// Equal to the delegate method "didSelectRowAtIndex" in UITableView.
    ///
    /// - Parameter indexPath: indexPath of cell which been selected.
    func tableViewDidSelectRowAt(indexPath: IndexPath)
}
