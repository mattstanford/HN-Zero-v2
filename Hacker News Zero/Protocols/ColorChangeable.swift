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
    func switchScheme(to scheme: ColorScheme)
}

extension ColorChangeable where Self: UIViewController  {
    
    func set(scheme: ColorScheme) {
        setColorOfNavBar(to: scheme)
        view.backgroundColor = scheme.contentBackgroundColor
    }
    
    func setColorOfNavBar(to scheme: ColorScheme) {
        navigationController?.navigationBar.barTintColor = scheme.barColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: scheme.barTextColor
        ]
        navigationController?.navigationItem.backBarButtonItem?.tintColor = scheme.barTextColor
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = scheme.barTextColor
        navigationController?.navigationBar.tintColor = scheme.barTextColor
        


    }
}
