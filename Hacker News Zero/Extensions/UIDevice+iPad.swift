//
//  UIDevice+iPad.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 7/10/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

extension UIDevice {

    static var isRunningOnIpad: Bool {
        return current.userInterfaceIdiom == .pad
    }
}
