//
//  ColorChangeable.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 6/11/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

protocol ColorChangeable {
    func set(scheme: ColorScheme)
}

extension ColorChangeable where Self: UIViewController  {
    
    func set(scheme: ColorScheme) {
        setColorOfNavBar(to: scheme)
        self.view.backgroundColor = scheme.backgroundColor
    }
    
    func setColorOfNavBar(to scheme: ColorScheme) {
        self.navigationController?.navigationBar.barTintColor = scheme.mainColor
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
