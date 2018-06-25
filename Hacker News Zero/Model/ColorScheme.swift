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
    let contentInfoTextColor: UIColor
    let contentLinkColor: UIColor
}

//MARK: - Defined scheme helper methods
extension ColorScheme {
    
    static let standard: ColorScheme = ColorScheme(barColor: UIColor.orange,
                                               barTextColor: UIColor.white,
                                               contentBackgroundColor: UIColor.white,
                                               contentTextColor: UIColor.black,
                                               contentInfoTextColor: UIColor.lightGray,
                                               contentLinkColor: UIColor.blue)
    
    static let dark: ColorScheme = ColorScheme(barColor: UIColor.black,
                                                   barTextColor: UIColor.white,
                                                   contentBackgroundColor: #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1),
                                                   contentTextColor: #colorLiteral(red: 0.9215686275, green: 0.9607843137, blue: 0.9725490196, alpha: 1),
                                                   contentInfoTextColor: UIColor.gray,
                                                   contentLinkColor: #colorLiteral(red: 0.1294117647, green: 0.7843137255, blue: 0.9803921569, alpha: 1))
    
    static let test: ColorScheme = ColorScheme(barColor: UIColor.orange,
                                                   barTextColor: UIColor.purple,
                                                   contentBackgroundColor: UIColor.yellow,
                                                   contentTextColor: UIColor.green,
                                                   contentInfoTextColor: UIColor.blue,
                                                   contentLinkColor: UIColor.orange)
}
