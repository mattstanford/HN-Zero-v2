//
//  ColorScheme.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 6/11/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

struct ColorScheme {
    let mainColor: UIColor
    let backgroundColor: UIColor
    let foregroundColor: UIColor
    let linkColor: UIColor
}

//MARK: - Defined scheme helper methods
extension ColorScheme {
    
    static let standard: ColorScheme = ColorScheme(mainColor: UIColor.orange,
                                                   backgroundColor: UIColor.yellow,
                                                   foregroundColor: UIColor.green,
                                                   linkColor: UIColor.purple)
}
