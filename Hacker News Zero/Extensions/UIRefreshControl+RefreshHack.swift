//
//  UIRefreshControl+RefreshHack.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 7/7/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    
    func beginManualRefresh(for tableView: UITableView) {
        tableView.contentOffset = CGPoint(x:0, y:-self.frame.size.height)
        beginRefreshing()
    }
}
