//
//  ColorScheme.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 6/11/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

struct ColorScheme {
    let barColor: UIColor
    let barTextColor: UIColor
    let contentBackgroundColor: UIColor
    let contentTextColor: UIColor
    let contentLinkColor: UIColor
}

//MARK: - Defined scheme helper methods
extension ColorScheme {
    
    static let standard: ColorScheme = ColorScheme(barColor: UIColor.orange,
                                                   barTextColor: UIColor.purple,
                                                   contentBackgroundColor: UIColor.yellow,
                                                   contentTextColor: UIColor.green,
                                                   contentLinkColor: UIColor.purple)
}
