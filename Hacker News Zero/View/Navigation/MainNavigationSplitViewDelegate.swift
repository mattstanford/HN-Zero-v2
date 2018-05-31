//
//  MainNavigationSplitViewDelegate.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/8/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationSplitViewDelegate : NSObject, UISplitViewControllerDelegate
{
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController:UIViewController,
                             onto primaryViewController:UIViewController) -> Bool
    {
        return true
    }
}
