//
//  MainNavigationSplitViewDelegate.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/8/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationSplitViewDelegate : UISplitViewControllerDelegate
{
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController:UIViewController,
                             onto primaryViewController:UIViewController) -> Bool
    {
        //        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        //        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false
        //
        //        }
        
        return true
    }
}
